% makaro.pl — Resolvedor genérico de Makaro (CLP(FD))
%
% Regras:
%   - Cada sala contém os valores 1..N exatamente uma vez (N = tamanho da sala).
%   - Células adjacentes de salas diferentes têm valores distintos.
%   - Setas: a célula preta aponta para o vizinho com o maior valor entre todos
%     os seus vizinhos de sala (value(dest) > value(N) para cada outro vizinho N).
%
% Para usar outro puzzle: substitua puzzle_makaro.pl mantendo os três
% predicados: tabuleiro/1, salas/1, setas/1.
% Consulta: ?- solucao(Tab), maplist(writeln, Tab).

:- use_module(library(clpfd)).
:- consult(puzzle_makaro).

% --- Sala ---

% Restringe variáveis ao domínio 1..N com all_distinct (arc consistency).
completa_sala(Vars, N) :-
    Vars ins 1..N,
    all_distinct(Vars).

% Extrai o valor da célula pos(R,C) do grid Tab (1-indexado).
celula(Tab, pos(R, C), V) :- nth1(R, Tab, Linha), nth1(C, Linha, V).

% Aplica completa_sala a cada sala.
aplica_salas(_, []).
aplica_salas(Tab, [sala(Poss, N)|Resto]) :-
    maplist(celula(Tab), Poss, Vars),
    completa_sala(Vars, N),
    aplica_salas(Tab, Resto).

% --- Costuras ---

% Vizinhos imediatos — só direita e abaixo para evitar pares duplicados.
vizinho(pos(R,C), pos(R,C2)) :- C2 is C + 1.
vizinho(pos(R,C), pos(R2,C)) :- R2 is R + 1.

% Retorna o índice da sala que contém Pos.
sala_de(Pos, Salas, Idx) :-
    nth1(Idx, Salas, sala(Poss, _)),
    member(Pos, Poss).

% Deriva todas as costuras diretamente das definições de sala.
gera_costuras(Salas, Costuras) :-
    findall(P1-P2, par_costura(Salas, P1, P2), Costuras).

par_costura(Salas, P1, P2) :-
    member(sala(Poss, _), Salas),
    member(P1, Poss),
    vizinho(P1, P2),
    sala_de(P1, Salas, S1),
    sala_de(P2, Salas, S2),
    S1 \== S2.

% Garante que cada par de células adjacentes de salas diferentes é distinto.
aplica_costuras(_, []).
aplica_costuras(Tab, [P1-P2|Resto]) :-
    celula(Tab, P1, V1),
    celula(Tab, P2, V2),
    V1 #\= V2,
    aplica_costuras(Tab, Resto).

% --- Setas ---

% Todos os 4 vizinhos ortogonais de uma posição.
vizinho_ortogonal(pos(R,C), pos(R,C2))  :- C2 is C+1.
vizinho_ortogonal(pos(R,C), pos(R,C2))  :- C2 is C-1.
vizinho_ortogonal(pos(R,C), pos(R2,C))  :- R2 is R+1.
vizinho_ortogonal(pos(R,C), pos(R2,C))  :- R2 is R-1.

% Impõe VDest #> VViz para um vizinho PViz da célula de seta.
seta_vizinho_menor(Tab, VDest, PViz) :-
    celula(Tab, PViz, VViz),
    VDest #> VViz.

% Aplica a regra de seta para uma entrada da lista.
% Caso 1: PArrow é célula de sala — comparação direta.
% Caso 2: PArrow é célula preta — PDest maior que todos os outros vizinhos de sala.
aplica_uma_seta(Tab, Salas, PArrow, PDest) :-
    sala_de(PArrow, Salas, _), !,
    celula(Tab, PArrow, VA),
    celula(Tab, PDest, VD),
    VA #> VD.
aplica_uma_seta(Tab, Salas, PArrow, PDest) :-
    celula(Tab, PDest, VDest),
    findall(PViz,
            (vizinho_ortogonal(PArrow, PViz), PViz \== PDest, sala_de(PViz, Salas, _)),
            Vizinhos),
    maplist(seta_vizinho_menor(Tab, VDest), Vizinhos).

aplica_setas(_, _, []).
aplica_setas(Tab, Salas, [PArrow-PDest|Resto]) :-
    aplica_uma_seta(Tab, Salas, PArrow, PDest),
    aplica_setas(Tab, Salas, Resto).

% --- Solver ---

% Coleta posições das células livres de sala (termos ground, seguros para findall)
% e extrai as variáveis reais do grid via maplist para garantir ligação correta.
variaveis_sala(Tab, Salas, Vars) :-
    findall(P,
            (member(sala(Poss,_), Salas), member(P, Poss), celula(Tab, P, V), var(V)),
            Posicoes),
    maplist(celula(Tab), Posicoes, Vars).

% Imprime o grid: inteiros como dígitos, variáveis livres como '#'.
celula_str(V, V) :- integer(V), !.
celula_str(_, '#').

imprime_tabuleiro(Tab) :-
    maplist([Linha]>>(
        maplist(celula_str, Linha, Strs),
        atomic_list_concat(Strs, '-', Linha_fmt),
        writeln(Linha_fmt)
    ), Tab).

% Ponto de entrada: Tab é o grid resolvido.
solucao(Tab) :-
    tabuleiro(Tab),
    salas(Salas),
    aplica_salas(Tab, Salas),
    gera_costuras(Salas, Costuras),
    aplica_costuras(Tab, Costuras),
    setas(Setas),
    aplica_setas(Tab, Salas, Setas),
    variaveis_sala(Tab, Salas, Vars),
    labeling([ff], Vars).
