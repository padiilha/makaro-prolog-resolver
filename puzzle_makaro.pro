% puzzle_makaro.pl — Configuração do puzzle Makaro 10×10
%
% Para usar outro puzzle: substitua este ficheiro por outro que defina
% tabuleiro/1, regioes/1 e setas/1 com o mesmo formato.
% As bordas são derivadas automaticamente a partir de regioes/1.
%
% Células de seta não pertencem a nenhuma região. O solver verifica todos os
% vizinhos ortogonais de região da célula preta; vizinhos fora do grid são
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

% Regiões: regiao(Posições, N) — a região usa os valores 1..N exatamente uma vez.
% Posição = pos(Linha, Coluna), 1-indexado.
regioes([
    regiao([pos(1,1), pos(1,2)],                                      2),  % região  1
    regiao([pos(1,4), pos(1,5), pos(2,4)],                            3),  % região  2
    regiao([pos(1,6), pos(1,7), pos(2,7), pos(3,7), pos(4,7)],        5),  % região  3
    regiao([pos(1,8), pos(1,9), pos(2,9), pos(2,10)],                 4),  % região  4
    regiao([pos(2,1), pos(3,1), pos(4,1)],                            3),  % região  5
    regiao([pos(2,2), pos(2,3), pos(3,2), pos(3,3)],                  4),  % região  6
    regiao([pos(2,5), pos(2,6), pos(3,5)],                            3),  % região  7
    regiao([pos(3,8), pos(3,9), pos(3,10)],                           3),  % região  8
    regiao([pos(4,3), pos(4,4), pos(5,1), pos(5,2), pos(5,3)],        5),  % região  9
    regiao([pos(4,6), pos(5,6), pos(6,6), pos(6,7), pos(7,7)],        5),  % região 10
    regiao([pos(4,9), pos(4,10), pos(5,9), pos(5,10)],                4),  % região 11
    regiao([pos(5,4), pos(5,5), pos(6,5)],                            3),  % região 12
    regiao([pos(5,7), pos(5,8)],                                      2),  % região 13
    regiao([pos(6,1), pos(7,1), pos(8,1)],                            3),  % região 14
    regiao([pos(6,4), pos(7,2), pos(7,3), pos(7,4)],                  4),  % região 15
    regiao([pos(6,9), pos(7,8), pos(7,9), pos(7,10)],                 4),  % região 16
    regiao([pos(7,5), pos(8,5), pos(8,6)],                            3),  % região 17
    regiao([pos(8,3), pos(9,3), pos(9,4), pos(10,2), pos(10,3)],      5),  % região 18
    regiao([pos(8,8), pos(8,9), pos(8,10)],                           3),  % região 19
    regiao([pos(9,1), pos(9,2)],                                      2),  % região 20
    regiao([pos(9,5), pos(10,5), pos(10,6)],                          3),  % região 21
    regiao([pos(9,7), pos(9,8), pos(9,9), pos(10,8)],                 4),  % região 22
    regiao([pos(10,9), pos(10,10)],                                   2)   % região 23
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
