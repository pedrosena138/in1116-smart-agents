% Source: https://ai.ia.agh.edu.pl/_media/pl:prolog:prolog_lab:birds.pl

:- dynamic(known/3).

main :- identify.

identify:-
  retractall(known(_,_,_)),
  order(O),
  family(F),         
  bird(B),
  nl, write('The order is '), write(O),nl,
  write('The family is '), write(F),nl,
  write('The bird is a '), write(B),nl.
identify:-
  write('I can''t identify that bird'),nl.

% Orders
order(tubenose):-
  nostrils(external_tubular),
  live(at_sea),
  bill(hooked).

order(waterfowl):-
  feet(webbed),
  bill(flat).

% Families
family(albatross):-
  order(tubenose),
  size(large),
  wings(long_narrow).

family(petrel):-
  order(tubenose),
  size(small),
  wings(short_narrow).

family(swan):-
  order(waterfowl),
  neck(long),
  color(white),
  flight(ponderous).

family(goose):-
  order(waterfowl),
  size(plump),
  flight(powerful).

family(duck):-
  order(waterfowl),
  feed(on_water_surface),
  flight(agile).

% Birds
bird(laysan_albatross):-
  family(albatross),
  color(white).

bird(black_footed_albatross):-
  family(albatross),
  color(dark).

bird(ashy_storm_petrel):-
  family(petrel),
  color(grey).

bird(black_storm_petrel):-
  family(petrel),
  color(dark).

bird(whistling_swan):-
  family(swan),
  voice(muffled_musical_whistle).

bird(trumpeter_swan):-
  family(swan),
  voice(loud_trumpeting).

bird(canada_goose):-
  family(goose),
  season(winter),                
  country(united_states),       
  head(black),                   
  cheek(white).

bird(canada_goose):-
  family(goose),
  season(summer),
  country(canada),
  head(black), 
  cheek(white).

bird(snow_goose):-
  family(goose),
  color(white).

bird(mallard):-             % different rules for male
  family(duck),                  
  voice(quack), 
  head(green).

bird(mallard):-
  family(duck),                  % and female
  voice(quack),
  color(mottled_brown).

bird(pintail):-
  family(duck),
  voice(short_whistle).

nostrils(X):- ask(nostrils,X).
live(X):- ask(live, X).
bill(X):- ask(bill, X).
size(X):- menuask(size, X, [large, plump, medium, small]).
feet(X):- ask(feet, X).
wings(X):- ask(wings, X).
neck(X):- ask(neck, X).
color(X):- ask(color, X).
flight(X):- menuask(flight, X, [ponderous, powerful, agile, other]).
feed(X):- ask(feed, X).
head(X):- ask(head, X).
voice(X):- ask(voice, X).
season(X):- menuask(season, X, [winter, summer]).
cheek(X):- ask(cheek, X).
country(X):- menuask(country, X, [canada, united_states]).

ask(Attribute,Value):-
  known(yes,Attribute,Value),       % succeed if we know its true
  !.                                % and dont look any further
ask(Attribute,Value):-
  known(_,Attribute,Value),         % fail if we know its false
  !, fail.

ask(Attribute,_):-
  known(yes,Attribute,_),           % fail if we know its some other value.
  !, fail.                          % the cut in clause #1 ensures that if
                                    % we get here the value is wrong.
ask(A,V):-
  write(A:V),                       % if we get here, we need to ask.
  write('? (yes or no): '),
  read(Y),                          % get the answer
  asserta(known(Y,A,V)),            % remember it so we dont ask again.
  Y = yes.                          % succeed or fail based on answer.

% "menuask" is like ask, only it gives the user a menu to to choose
% from rather than a yes on no answer. In this case there is no
% need to check for a negative since "menuask" ensures there will
% be some positive answer.

menuask(Attribute,Value,_):-
  known(yes,Attribute,Value),       % succeed if we know
  !.
menuask(Attribute,_,_):-
  known(yes,Attribute,_),           % fail if its some other value
  !, fail.

menuask(Attribute,AskValue,Menu):-
  nl,write('What is the value for '),write(Attribute),write('?'),nl,
  display_menu(Menu),
  write('Enter the number of choice> '),
  read(Num),nl,
  pick_menu(Num,AnswerValue,Menu),
  asserta(known(yes,Attribute,AnswerValue)),
  AskValue = AnswerValue.           % succeed or fail based on answer

display_menu(Menu):-
  disp_menu(1,Menu), !.             % make sure we fail on backtracking

disp_menu(_,[]).
disp_menu(N,[Item | Rest]):-        % recursively write the head of
  write(N),write(' : '),write(Item),nl, % the list and disp_menu the tail
  NN is N + 1,
  disp_menu(NN,Rest).

pick_menu(N,Val,Menu):-
  integer(N),                       % make sure they gave a number
  pic_menu(1,N,Val,Menu), !.        % start at one
  pick_menu(Val,Val,_).             % if they didn't enter a number, use
                                    % what they entered as the value

pic_menu(_,_,none_of_the_above,[]). % if we've exhausted the list
pic_menu(N,N, Item, [Item|_]).      % the counter matches the number
pic_menu(Ctr,N, Val, [_|Rest]):-
  NextCtr is Ctr + 1,               % try the next one
  pic_menu(NextCtr, N, Val, Rest).
