:-style_check(-singleton).

:- dynamic
  known/3,
  nostrils/1,
	voice/1,
	cheek/1,
	head/1,
	flight/1,
	bill/1,
	live/1.

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
  asserta(known(yes, A, X) ),
  X == V.

check_val(X, A, V, MenuList) :- member(X, MenuList), !.

check_val(X, A, V, MenuList) :-
  write(X), write(' is not a legal value, try again.'), nl,
  option_input(A, V, MenuList).

bird(laysan_albatross):-
  family(albatross),
  color(white).

bird(black_footed_albatross):-
  family(albatross),
  color(dark).

bird(whistling_swan) :-
  family(swan),
  voice(muffled_musical_whistle).

bird(trumpeter_swan) :-
  family(swan),
  voice(loud_trumpeting).

% Families
family(albatross) :-
  nostrils(external_tubular),
  live(at_sea),
  bill(hooked),
  size(large),
  wings(long_narrow).

family(swan) :-
  feet(webbed),
  bill(flat),
  neck(long),
  color(white),
  flight(ponderous).

nostrils(X):- input(nostrils, X).
feet(X):- input(feet, X).
live(X):- input(live, X).
bill(X):- input(bill, X).
size(X):- input(size, X).
wings(X):- input(wings, X).
neck(X):- input(neck, X).
color(X):- input(color, X).
flight(X):- input(flight, X).
voice(X):- input(voice, X).

multivalued(voice).
multivalued(bill).
multivalued(color).

top_goal(F, B):-
    (family(F), bird(B)),
    !.

solve :-
  top_goal(F, B), nl,
  write('The bird family is '), write(F), nl,
  write('The bird is '), write(B), nl, !.

solve :-
  nl, write('No answer found.'), nl, !.