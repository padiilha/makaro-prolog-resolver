# Makaro — Resolvedor em Prolog

**Disciplina:** INE5416 – Paradigmas de Programação  
**Alunos:**

- Cauã Pablo Padilha (22100895)
- Lucas Pagotto Coutinho de Oliveira (18201971)

---

## O puzzle

Makaro é um puzzle lógico jogado em uma grade dividida em **salas** (regiões).

**Regras:**

- Cada sala de tamanho N contém os valores **1 até N exatamente uma vez**.
- Células adjacentes ortogonalmente que pertencem a **salas diferentes** devem ter valores distintos.
- Células **pretas com seta** apontam para o vizinho ortogonal com o **maior valor** entre todos os vizinhos de sala daquela célula preta — ou seja, o valor da célula destino é maior que o de todos os outros vizinhos que pertencem a alguma sala.
- Células **pretas sem seta** não pertencem a nenhuma sala e não recebem valor.

---

## Como executar

### Direto pelo terminal (recomendado)

```bash
swipl -g "solucao(Tab), imprime_tabuleiro(Tab), halt" makaro.pl
```

### Interativo

```bash
swipl makaro.pl
```

No prompt `?-`:

```prolog
?- solucao(Tab), imprime_tabuleiro(Tab).
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

Edite apenas o arquivo `puzzle_makaro.pl`, definindo três predicados:

### `tabuleiro/1`

Grade N×N com os valores já conhecidos (pistas fixas) e `_` para células livres:

```prolog
tabuleiro([
    [_,2,_,_,1,_,5,_,_,_],
    [3,_,1,3,_,_,3,_,4,_],
    ...
]).
```

### `salas/1`

Lista de salas no formato `sala(Posições, N)`, onde `N` é o tamanho da sala e `Posições` é a lista de células `pos(Linha, Coluna)` (1-indexado):

```prolog
salas([
    sala([pos(1,1), pos(1,2)], 2),
    sala([pos(1,4), pos(1,5), pos(2,4)], 3),
    ...
]).
```

> As costuras (restrições entre salas adjacentes) são **derivadas automaticamente** a partir das salas — não é necessário listá-las.

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

| Arquivo | O que faz |
|---|---|
| `makaro.pl` | Resolvedor genérico — restrições, solver, impressão |
| `puzzle_makaro.pl` | Configuração do puzzle — grade, salas e setas |

### `makaro.pl` — seções principais

| Seção | O que faz |
|---|---|
| **Salas** | `completa_sala/2` — impõe `1..N` e `all_distinct` via CLP(FD) |
| **Costuras** | `gera_costuras/2` — deriva automaticamente pares de células adjacentes de salas distintas; `aplica_costuras/2` — impõe `#\=` entre elas |
| **Setas** | `aplica_uma_seta/4` — impõe `VDest #> VViz` para todos os vizinhos de sala da célula preta |
| **Solver** | `solucao/1` — monta as restrições e chama `labeling([ff], Vars)` |
| **Saída** | `imprime_tabuleiro/1` — imprime a grade com `-` e `#` para células pretas |

### Algoritmo

O solver usa **programação por restrições** com CLP(FD):

```
1. Criar variáveis para cada célula livre do tabuleiro.
2. Aplicar restrições de sala: domínio 1..N + all_distinct.
3. Derivar e aplicar costuras: células adjacentes de salas distintas ≠.
4. Aplicar restrições de seta: valor destino > todos os outros vizinhos de sala.
5. labeling([ff], Vars): busca com heurística first-fail — tenta primeiro a
   variável com menor domínio restante, reduzindo o espaço de busca.
```
