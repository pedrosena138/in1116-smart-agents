:-style_check(-singleton).

% Regras para identificar o parasito humano com base no habitat
parasitose(Doenca, parasito_intestinal) :- habita(Doenca, intestino).
parasitose(Doenca, parasito_sanguineo) :- habita(Doenca, sangue).

% Regras para identificar o tipo de parasito
tipo(Doenca, helminto) :- reino(Doenca, animal).
tipo(Doenca, protozoario) :- reino(Doenca, protista).

% Fatos
habita(ascaridiase, intestino).
habita(tricuriase, intestino).
habita(ancilostomiase, intestino).
habita(amebiase, intestino).
habita(giardiase, intestino).
habita(esquistossomose_mansoni, sangue).
habita(doenca_de_chagas, sangue).
habita(leishmaniose, sangue).


reino(ascaridiase, animal).
reino(tricuriase, animal).
reino(ancilostomiase, animal).
reino(esquistossomose_mansoni, animal).
reino(amebiase, protista).
reino(giardiase, protista).
reino(doenca_de_chagas, protista).
reino(leishmaniose, protista).


sintoma(ascaridiase, obstrucao_intestinal).
sintoma(tricuriase, prolapso_retal).
sintoma(ancilostomiase, anemia_grave).
sintoma(amebiase, ulceras_intestinais).
sintoma(giardiase, ma_absorca_de_nutrientes).
sintoma(esquistossomose_mansoni, hepatose_plenomegalia).
sintoma(doenca_de_chagas, infertilidade).
sintoma(leishmaniose, ulceras_na_pele).

doenca(Doenca, Habita, Sintoma, Reino, Tipo, Parasitose) :-
  habita(Doenca, Habita),
  parasitose(Doenca, Parasitose),
  reino(Doenca, Reino),
  tipo(Doenca, Tipo),
  sintoma(Doenca, Sintoma).