# Spec Delta

## ADDED Requirements

### Requirement: Volume della notifica

Con il tipo «Notifica» l'utente SHALL poter scegliere il volume dell'avviso tra «Volume applicazioni» (predefinito) e «Volume suoneria». Con «Volume applicazioni» il suono SHALL seguire il volume Applicazioni, SHALL essere riprodotto anche con «non disturbare» e il banner SHALL comparire una sola volta per avviso, anche in loop. Con «Volume suoneria» il suono SHALL seguire il volume Suoneria e MUST NOT essere riprodotto con «non disturbare». La scelta SHALL restare salvata.

#### Scenario: Volume predefinito
- **WHEN** l'utente apre l'app per la prima volta
- **THEN** il tipo è «Notifica» e il volume è «Volume applicazioni»

#### Scenario: Volume applicazioni
- **WHEN** il volume è «Volume applicazioni», l'utente abbassa il volume con i tasti mentre l'app è aperta e il lavoro finisce
- **THEN** l'avviso suona al volume più basso e il volume Suoneria non è cambiato

#### Scenario: Volume applicazioni col profilo silenzioso
- **WHEN** il volume è «Volume applicazioni», il telefono è nel profilo silenzioso e il lavoro finisce
- **THEN** l'avviso non emette suono e «Lavoro» diventa comunque scaduto

#### Scenario: Volume applicazioni con non disturbare
- **WHEN** il volume è «Volume applicazioni», «non disturbare» è attivo e il lavoro finisce
- **THEN** l'avviso è udibile

#### Scenario: Volume suoneria con non disturbare
- **WHEN** il volume è «Volume suoneria», «non disturbare» è attivo e il lavoro finisce
- **THEN** l'avviso non emette suono e «Lavoro» diventa comunque scaduto

#### Scenario: Un solo banner in loop
- **WHEN** il volume è «Volume applicazioni», la ripetizione è «In loop», il lavoro finisce e l'utente preme «Stop» dopo 30 secondi
- **THEN** il suono si ripete per quei 30 secondi e il banner compare una sola volta

#### Scenario: Volume conservato
- **WHEN** l'utente sceglie «Volume suoneria», chiude l'app e la riapre
- **THEN** il volume è «Volume suoneria»
