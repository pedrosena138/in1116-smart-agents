%Regras
% Seta a variável Motor como dinâmica para ser usada na memória de trabalho.
:- dynamic
  motor/2.

veiculoTipo(Veiculo, ciclo) :-
    num_rodas(Veiculo, N), N < 4.

veiculoTipo(Veiculo, automovel) :-
    num_rodas(Veiculo, 4), asserta(motor(Veiculo, sim)).

veiculo(Veiculo, Rodas, Motor, Tamanho, NumPortas, Tipo) :-
    veiculoTipo(Veiculo, Tipo),
    num_rodas(Veiculo, Rodas),
    motor(Veiculo, Motor),
    tamanho(Veiculo, Tamanho),
    num_portas(Veiculo, NumPortas),
    !.

veiculo(Veiculo, Rodas, Motor, _, _, Tipo) :-
    veiculoTipo(Veiculo, Tipo),
    num_rodas(Veiculo, Rodas),
    motor(Veiculo, Motor),
    Tipo == ciclo,
    !.



%Fatos
num_rodas(bicicleta, 2).
num_rodas(triciclo, 3).
num_rodas(motocicleta, 2).
num_rodas(carroSport, 4).
num_rodas(sedan, 4).
num_rodas(miniVan, 4).
num_rodas(utilitarioSport, 4).


motor(bicicleta, nao).
motor(triciclo, nao).
motor(motocicleta, sim).

tamanho(carroSport, pequeno).
tamanho(sedan, médio).
tamanho(miniVan, médio).
tamanho(utilitarioSport, grande).

num_portas(carroSport, 2).
num_portas(sedan, 4).
num_portas(miniVan, 3).
num_portas(utilitarioSport, 4).