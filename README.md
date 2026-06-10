# Makaro — Resolvedor em Prolog

**Disciplina:** INE5416 – Paradigmas de Programação  
**Alunos:**

- Cauã Pablo Padilha (22100895)
- Lucas Pagotto Coutinho de Oliveira (18201971)

---

## O puzzle

Makaro é um puzzle lógico jogado em uma grade dividida em **regiões**.

**Regras:**

- Cada região de tamanho N contém os valores **1 até N exatamente uma vez**.
- Células adjacentes ortogonalmente que pertencem a **regiões diferentes** devem ter valores distintos.
- Células **pretas com seta** apontam para o vizinho ortogonal com o **maior valor** entre todos os vizinhos de região daquela célula preta — ou seja, o valor da célula destino é maior que o de todos os outros vizinhos que pertencem a alguma região.
- Células **pretas sem seta** não pertencem a nenhuma região e não recebem valor.

---

## Como executar

### Direto pelo terminal (recomendado)

```bash
swipl -g "resolve, halt" makaro.pro
```

### Interativo

```bash
swipl makaro.pro
```

No prompt `?-`:

```prolog
?- resolve.
```

A saída usa `-` como separador entre células e `#` para células pretas:

```
1-2-#-2-1-2-5-1-3-#
3-4-1-3-2-1-3-#-4-2
2-3-2-#-3-#-1-2-3-1
...
```

---

## Como configurar um puzzle

Edite apenas o arquivo `puzzle_makaro.pro`, definindo três predicados:

### `tabuleiro/1`

Grade N×N com os valores já conhecidos (pistas fixas) e `_` para células livres:

```prolog
tabuleiro([
    [_,2,_,_,1,_,5,_,_,_],
    [3,_,1,3,_,_,3,_,4,_],
    ...
]).
```

### `regioes/1`

Lista de regiões no formato `regiao(Posições, N)`, onde `N` é o tamanho da região e `Posições` é a lista de células `pos(Linha, Coluna)` (1-indexado):

```prolog
regioes([
    regiao([pos(1,1), pos(1,2)], 2),
    regiao([pos(1,4), pos(1,5), pos(2,4)], 3),
    ...
]).
```

> As bordas (restrições entre regiões adjacentes) são **derivadas automaticamente** a partir das regiões — não é necessário listá-las.

### `setas/1`

Lista de pares `PosOrigem-PosDestino`, onde `PosOrigem` é a célula preta com seta e `PosDestino` é a célula para onde ela aponta:

```prolog
setas([
    pos(1,10)-pos(1,9),
    pos(2,8)-pos(2,9),
    ...
]).
```

---

## Estrutura do código

| Arquivo             | O que faz                                           |
| ------------------- | --------------------------------------------------- |
| `makaro.pro`        | Resolvedor genérico — restrições, solver, impressão |
| `puzzle_makaro.pro` | Configuração do puzzle — grade, regiões e setas     |

### `makaro.pro` — seções principais

| Seção      | O que faz                                                                                                                             |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| **Região** | `completa_regiao/2` — impõe `1..N` e `all_distinct` via CLP(FD)                                                                       |
| **Bordas** | `gera_bordas/2` — deriva automaticamente pares de células adjacentes de regiões distintas; `aplica_bordas/2` — impõe `#\=` entre elas |
| **Setas**  | `aplica_uma_seta/4` — impõe `VDest #> VViz` para todos os vizinhos de região da célula preta                                          |
| **Solver** | `solucao/1` — monta as restrições e chama `labeling([ff], Vars)`                                                                      |
| **Saída**  | `imprime_tabuleiro/1` — imprime a grade com `-` e `#` para células pretas                                                             |

### Algoritmo

O solver usa **programação por restrições** com CLP(FD):

```
1. Criar variáveis para cada célula livre do tabuleiro.
2. Aplicar restrições de região: domínio 1..N + all_distinct.
3. Derivar e aplicar bordas: células adjacentes de regiões distintas ≠.
4. Aplicar restrições de seta: valor destino > todos os outros vizinhos de região.
5. labeling([ff], Vars): busca com heurística first-fail — tenta primeiro a
   variável com menor domínio restante, reduzindo o espaço de busca.
```
