% puzzle_makaro.pl — Configuração do puzzle Makaro 10×10
%
% Para usar outro puzzle: substitua este ficheiro por outro que defina
% tabuleiro/1, salas/1 e setas/1 com o mesmo formato.
% As costuras são derivadas automaticamente a partir de salas/1.
%
% Células de seta não pertencem a nenhuma sala. O solver verifica todos os
% vizinhos ortogonais de sala da célula preta; vizinhos fora do grid são
% ignorados, mas os demais (acima, abaixo, esquerda, direita) são considerados.

% Grade 10×10. Números são pistas fixas; _ são células livres.
tabuleiro([
    [_,2,_,_,1,_,5,_,_,_],
    [3,_,1,3,_,_,3,_,4,_],
    [2,_,_,_,_,_,1,2,_,1],
    [_,_,3,_,_,_,_,_,_,3],
    [2,_,_,3,_,_,_,_,2,_],
    [1,_,_,_,_,2,1,_,_,_],
    [_,1,_,_,_,_,_,2,3,_],
    [2,_,2,_,_,_,_,_,_,3],
    [_,2,_,_,2,_,_,4,3,_],
    [_,3,_,_,3,_,_,_,_,1]
]).

% Salas: sala(Posições, N) — a sala usa os valores 1..N exatamente uma vez.
% Posição = pos(Linha, Coluna), 1-indexado.
salas([
    sala([pos(1,1), pos(1,2)],                                      2),  % sala  1
    sala([pos(1,4), pos(1,5), pos(2,4)],                            3),  % sala  2
    sala([pos(1,6), pos(1,7), pos(2,7), pos(3,7), pos(4,7)],        5),  % sala  3
    sala([pos(1,8), pos(1,9), pos(2,9), pos(2,10)],                 4),  % sala  4
    sala([pos(2,1), pos(3,1), pos(4,1)],                            3),  % sala  5
    sala([pos(2,2), pos(2,3), pos(3,2), pos(3,3)],                  4),  % sala  6
    sala([pos(2,5), pos(2,6), pos(3,5)],                            3),  % sala  7
    sala([pos(3,8), pos(3,9), pos(3,10)],                           3),  % sala  8
    sala([pos(4,3), pos(4,4), pos(5,1), pos(5,2), pos(5,3)],        5),  % sala  9
    sala([pos(4,6), pos(5,6), pos(6,6), pos(6,7), pos(7,7)],        5),  % sala 10
    sala([pos(4,9), pos(4,10), pos(5,9), pos(5,10)],                4),  % sala 11
    sala([pos(5,4), pos(5,5), pos(6,5)],                            3),  % sala 12
    sala([pos(5,7), pos(5,8)],                                      2),  % sala 13
    sala([pos(6,1), pos(7,1), pos(8,1)],                            3),  % sala 14
    sala([pos(6,4), pos(7,2), pos(7,3), pos(7,4)],                  4),  % sala 15
    sala([pos(6,9), pos(7,8), pos(7,9), pos(7,10)],                 4),  % sala 16
    sala([pos(7,5), pos(8,5), pos(8,6)],                            3),  % sala 17
    sala([pos(8,3), pos(9,3), pos(9,4), pos(10,2), pos(10,3)],      5),  % sala 18
    sala([pos(8,8), pos(8,9), pos(8,10)],                           3),  % sala 19
    sala([pos(9,1), pos(9,2)],                                      2),  % sala 20
    sala([pos(9,5), pos(10,5), pos(10,6)],                          3),  % sala 21
    sala([pos(9,7), pos(9,8), pos(9,9), pos(10,8)],                 4),  % sala 22
    sala([pos(10,9), pos(10,10)],                                   2)   % sala 23
]).

% Setas: pares (Origem, Destino) onde o valor na origem deve ser maior.
setas([
    pos(1,10)-pos(1,9),
    pos(2,8)-pos(2,9),
    pos(3,4)-pos(4,4),
    pos(3,6)-pos(4,6),
    pos(4,2)-pos(5,2),
    pos(4,5)-pos(4,6),
    pos(6,2)-pos(5,2),
    pos(6,3)-pos(7,3),
    pos(6,8)-pos(6,9),
    pos(6,10)-pos(6,9),
    pos(7,6)-pos(7,7),
    pos(8,4)-pos(9,4),
    pos(8,7)-pos(7,7),
    pos(9,6)-pos(8,6),
    pos(10,1)-pos(10,2),
    pos(10,4)-pos(10,3),
    pos(10,7)-pos(9,7)
]).
