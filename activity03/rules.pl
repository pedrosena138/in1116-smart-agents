:- consult(inputs).

:- discontiguous
  input/2,
  option_input/3.

:- dynamic
  known/3,
  nostrils/1,
	voice/1,
	cheek/1,
	head/1,
	flight/1,
	bill/1,
	live/1.

:- set_prolog_flag(unknown, error).

% Birds
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

% Orders
order(tubenose) :-
  nostrils(external_tubular),
  live(at_sea),
  bill(hooked).

order(waterfowl) :-
  feet(webbed),
  bill(flat).

% Families
family(albatross) :-
  order(tubenose),
  size(large),
  wings(long_narrow).

family(swan) :-
  order(waterfowl),
  neck(long),
  color(white),
  flight(ponderous).

nostrils(X):- input(nostrils, X).
feet(X):- input(feet, X).
live(X):- input(live, X).
bill(X):- input(bill, X).
wings(X):- input(wings, X).
neck(X):- input(neck, X).
color(X):- input(color, X).

size(X):- option_input(size, X, [large, plump, medium, small]).
flight(X):- option_input(flight, X, [ponderous, agile, flap_glide]).

multivalued(voice).
multivalued(feed).

top_goal(X):- bird(X).
