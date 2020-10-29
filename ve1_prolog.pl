/*
Bruno Mello - 18404
Menezes - 18410
Primeira VE de ProLog

1. soma_lista([1,2,3,4],K).
    K = [1,3,6,10]

2. Considere 8 letras diferentes.
   Compare duas listas formadas por 4 letras com repetição nas listas,
   e resposta quantos elementos da lista são iguais na posição correta
   e quantos são iguais mas em uma posição errada. Ex: p([a,b,c,d],[b,e,b,d],X,Y) devera retornar X=1 e Y = 1.

3. Defina um predicado junte(L,K,M) que, dadas duas listas ordenadas sem repetição de inteiros L and K,
   retorne uma lista ordenada sem repetição de inteiros M contendo todos os elementos de L e K. 

4. Defina o predicado prog (L1, L2, L) que dadas duas listas L1 e L2 com repetição,
   nos retorna a interseção sem repetição L dessas listas.
   Exemplo: prog([2,7,2,11], [3,4,5,2,8,2,7], L) nos dará a resposta L=[2,7] ou qualquer permutação dessa lista.
*/

% predicados uteis

tamanho_lista([], 0).

tamanho_lista([_|X], Z):-
  tamanho_lista(X, Y),
  Z is Y+1.

ultimo_lista([X], X).

ultimo_lista([_|X], Z):-
  ultimo_lista(X, Z).

membro_lista(X, [X|_]).

membro_lista(Y, [_|X]):-
  membro_lista(Y, X). 

lista_sem_duplicados([], []).

lista_sem_duplicados([X1|X2], Y):-
  membro_lista(X1, X2),
  lista_sem_duplicados(X2, Y).

lista_sem_duplicados([X1|X2], Y):-
  lista_sem_duplicados(X2, Z),
  Y = [X1|Z].

% questao 1

lista_sem_ultimo([], []).

lista_sem_ultimo([X1|X2], K) :-
  tamanho_lista(X2, L),
  L = 1,
  K = [X1].

lista_sem_ultimo([X1|X2], K) :-
  lista_sem_ultimo(X2, Y),
  K = [X1|Y].

soma_lista([], []).

soma_lista([X1|X2], K) :-
  tamanho_lista(X2, L),
  L = 0,
  K = [X1].

soma_lista(X, K) :-
  lista_sem_ultimo(X, Y),
  soma_lista(Y, Z),
  ultimo_lista(Z, W),
  ultimo_lista(X, P),
  C is W+P,
  append(Z, [C], K).

% questao 2

posicao_certa([], _, 0).

posicao_certa(_, [], 0).

posicao_certa([X1|X2], [Y1|Y2], Z) :-
  X1 = Y1,
  posicao_certa(X2, Y2, Z1),
  Z is Z1+1.

posicao_certa([_|X2], [_|Y2], Z) :-
  posicao_certa(X2, Y2, Z1),
  Z is Z1.

posicao_errada(_, [], 0).
posicao_errada([], _, 0).

posicao_errada([X1|X2], Y, Z) :-
  membro_lista(X1, Y),
  posicao_errada(X2, Y, Z1),
  Z is Z1+1.

posicao_errada([_|X2], Y, Z) :-
  posicao_errada(X2, Y, Z1),
  Z is Z1.

p(L, M, X, Y) :-
  posicao_certa(L, M, X),
  posicao_errada(L, M, Z),
  Y is Z-X.

% questao 3

junte(L, [], M) :-
  M = L.

junte([], L, M) :-
  M = L.

junte([L1|L2], [K1|K2], M) :-
  L1 > K1,
  junte([K1|K2], [L1|L2], M).

junte([L1|L2], [K1|K2], M) :-
  L1 is K1,
  junte(K2, [L1|L2], M).

junte([L1|L2], [K1|K2], M) :-
  junte(L2, [K1|K2], N),
  M = [L1|N].

% questao 4

prog_prev(_, [], []).
prog_prev([], _, []).

prog_prev([K1|K2], L2, [K1|R]):-
  membro_lista(K1, L2),
  prog(K2, L2, R).

prog_prev([_|K2], L2, L):-
  prog(K2, L2, L).

prog(X, Y, Z):-
  lista_sem_duplicados(X, X1),
  lista_sem_duplicados(Y, Y1),
  prog_prev(X1, Y1, Z).
