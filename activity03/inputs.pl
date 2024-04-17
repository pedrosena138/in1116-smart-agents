:- dynamic
  known/3.

:- discontiguous
  multivalued/1.

:-style_check(-singleton).

input(A, V):-
  known(yes, A, V), % succeed if true
  !. % stop looking

input(A, V):-
  known(_, A, V), % fail if false
  !, fail.

% known is barfing
input(A, V):-
  write(A), write(': '), write(V), % ask user
  write('? '),
  read(Y), % get the answer
  asserta(known(Y, A, V)), % remember it
  Y == yes. % succeed or fail

input(A, V):-
	\+ multivalued(A),
	known(yes, A, V2),
	V \== V2,
	!, fail.

option_input(A, V, OptionList) :-
  write('What is the value for '), write(A), write('? '), write(OptionList), nl,
  read(X),
  check_val(X, A, V, OptionList),
  asserta( known(yes, A, X) ),
  X == V.

check_val(X, A, V, MenuList) :- member(X, MenuList), !.

check_val(X, A, V, MenuList) :-
  write(X), write(' is not a legal value, try again.'), nl,
  option_input(A, V, MenuList).

