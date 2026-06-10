% makaro.pro — Resolvedor de Makaro em Prolog utilizando (CLP(FD))
%
% Regras:
%   - Cada região contém os valores 1..N exatamente uma vez (N = tamanho da região).
%   - Células adjacentes de regiões diferentes têm valores distintos.
%   - Setas: a célula preta aponta para o vizinho com o maior valor entre todos
%     os seus vizinhos de região (value(dest) > value(N) para cada outro vizinho N).
%
% Para usar outro puzzle: substitua puzzle_makaro.pro mantendo os três
% predicados: tabuleiro/1, regioes/1, setas/1.
% Consulta: ?- resolve.

:- use_module(library(clpfd)).
:- consult('puzzle_makaro.pro').

% --- Região ---

% Restringe variáveis ao domínio 1..N com all_distinct.
completa_regiao(Vars, N) :-
    Vars ins 1..N,
    all_distinct(Vars).

% Extrai o valor da célula pos(R,C) do grid Tab (1-indexado).
celula(Tabuleiro, pos(R, C), Valor) :-
    nth1(R, Tabuleiro, Linha),  % pega a linha R do grid
    nth1(C, Linha, Valor).      % pega a coluna C da linha -> valor

% Aplica completa_regiao a cada região.
aplica_regioes(_, []).
aplica_regioes(Tabuleiro, [regiao(Posicoes, N)|Resto]) :-
    maplist(celula(Tabuleiro), Posicoes, Vars),
    completa_regiao(Vars, N),
    aplica_regioes(Tabuleiro, Resto).

% --- Bordas ---

% Vizinhos imediatos — só direita e abaixo para evitar pares duplicados.
vizinho(pos(R,C), pos(R,C2)) :- C2 is C + 1.
vizinho(pos(R,C), pos(R2,C)) :- R2 is R + 1.

% Retorna o índice (identidade) da região que contém Pos.
regiao_de(Pos, Regioes, IdRegiao) :-
    nth1(IdRegiao, Regioes, regiao(Posicoes, _)),
    member(Pos, Posicoes).

% Deriva todas as bordas diretamente das definições de região.
gera_bordas(Regioes, Bordas) :-
    findall(P1-P2, par_borda(Regioes, P1, P2), Bordas).

par_borda(Regioes, P1, P2) :-
    member(regiao(Posicoes, _), Regioes),
    member(P1, Posicoes),
    vizinho(P1, P2),
    regiao_de(P1, Regioes, R1),
    regiao_de(P2, Regioes, R2),
    R1 \== R2.

% Garante que cada par de células adjacentes de regiões diferentes é distinto.
aplica_bordas(_, []).
aplica_bordas(Tabuleiro, [P1-P2|Resto]) :-
    celula(Tabuleiro, P1, V1),
    celula(Tabuleiro, P2, V2),
    V1 #\= V2,
    aplica_bordas(Tabuleiro, Resto).

% --- Setas ---

% Todos os 4 vizinhos ortogonais de uma posição.
vizinho_ortogonal(pos(R,C), pos(R,C2))  :- C2 is C+1.
vizinho_ortogonal(pos(R,C), pos(R,C2))  :- C2 is C-1.
vizinho_ortogonal(pos(R,C), pos(R2,C))  :- R2 is R+1.
vizinho_ortogonal(pos(R,C), pos(R2,C))  :- R2 is R-1.

% Impõe ValorDestino #> ValorVizinho para um vizinho PosVizinho da célula de seta.
seta_vizinho_menor(Tabuleiro, ValorDestino, PosVizinho) :-
    celula(Tabuleiro, PosVizinho, ValorVizinho),
    ValorDestino #> ValorVizinho.

% Aplica a regra de seta para uma entrada da lista.
% Caso 1: PosSeta é célula de região — comparação direta.
% Caso 2: PosSeta é célula preta — PosDestino maior que todos os outros vizinhos de região.
aplica_uma_seta(Tabuleiro, Regioes, PosSeta, PosDestino) :-
    regiao_de(PosSeta, Regioes, _), !,
    celula(Tabuleiro, PosSeta, ValorSeta),
    celula(Tabuleiro, PosDestino, ValorDestino),
    ValorSeta #> ValorDestino.
aplica_uma_seta(Tabuleiro, Regioes, PosSeta, PosDestino) :-
    celula(Tabuleiro, PosDestino, ValorDestino),
    findall(PosViz,
            (vizinho_ortogonal(PosSeta, PosViz), PosViz \== PosDestino, regiao_de(PosViz, Regioes, _)),
            Vizinhos),
    maplist(seta_vizinho_menor(Tabuleiro, ValorDestino), Vizinhos).

aplica_setas(_, _, []).
aplica_setas(Tabuleiro, Regioes, [PosSeta-PosDestino|Resto]) :-
    aplica_uma_seta(Tabuleiro, Regioes, PosSeta, PosDestino),
    aplica_setas(Tabuleiro, Regioes, Resto).

% --- Solver ---

% Coleta posições das células livres de região (termos ground, seguros para findall)
% e extrai as variáveis reais do grid via maplist para garantir ligação correta.
variaveis_regiao(Tabuleiro, Regioes, Vars) :-
    findall(Pos,
            (member(regiao(Posicoes,_), Regioes), member(Pos, Posicoes), celula(Tabuleiro, Pos, V), var(V)),
            PosicoesCelulasLivres),
    maplist(celula(Tabuleiro), PosicoesCelulasLivres, Vars).

% Imprime o grid: inteiros como dígitos, variáveis livres como '#'.
celula_str(V, V) :- integer(V), !.
celula_str(_, '#').

imprime_tabuleiro(Tabuleiro) :-
    maplist([Linha]>>(
        maplist(celula_str, Linha, Valores),
        atomic_list_concat(Valores, '-', LinhaFormatada),
        writeln(LinhaFormatada)
    ), Tabuleiro).

% Resolve e imprime sem expor variáveis ao prompt interativo.
resolve :- solucao(Tab), imprime_tabuleiro(Tab), !.

% Ponto de entrada: Tabuleiro é o grid resolvido.
solucao(Tabuleiro) :-
    tabuleiro(Tabuleiro),
    regioes(Regioes),
    aplica_regioes(Tabuleiro, Regioes),
    gera_bordas(Regioes, Bordas),
    aplica_bordas(Tabuleiro, Bordas),
    setas(Setas),
    aplica_setas(Tabuleiro, Regioes, Setas),
    variaveis_regiao(Tabuleiro, Regioes, Vars),
    labeling([ff], Vars).
