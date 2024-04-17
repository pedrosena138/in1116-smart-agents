:- consult(rules).

:- discontiguous
  top_goal/1.

:- dynamic
  known/3,
  define/1.


:- set_prolog_flag(unknown, error).

solve :-
  top_goal(X),
  nl, write('The answer is '), write(X), nl.

solve :-
  nl, write('No answer found.'), nl.
  
greeting :-
  write('This is the Bird Classifier Program'), nl.

run :-
  greeting,
  solve.