# Spec Delta

## MODIFIED Requirements

### Requirement: Tipo di avviso

L'utente SHALL poter scegliere il tipo di avviso tra «Suono» (predefinito), «Notifica» e «Sveglia». Con «Suono» l'avviso SHALL seguire il volume delle applicazioni, con «Notifica» quello della suoneria; entrambi SHALL essere muti col profilo silenzioso e con «non disturbare». Con «Sveglia» l'avviso SHALL usare la sveglia di sistema, con la suoneria e il volume della sveglia scelti dall'utente, e SHALL essere udibile anche col profilo silenzioso. La scelta SHALL restare salvata anche dopo la chiusura dell'app.

#### Scenario: Tipo predefinito
- **WHEN** l'utente apre l'app per la prima volta
- **THEN** il tipo di avviso è «Suono»

#### Scenario: Suono al volume delle applicazioni
- **WHEN** il tipo è «Suono», l'utente abbassa il volume con i tasti mentre l'app è aperta e il lavoro finisce
- **THEN** l'avviso suona al volume più basso e il volume della suoneria non è cambiato

#### Scenario: Suono col profilo silenzioso
- **WHEN** il tipo è «Suono», il telefono è nel profilo silenzioso e il lavoro finisce
- **THEN** l'avviso non emette suono e «Lavoro» diventa comunque scaduto

#### Scenario: Suono con non disturbare
- **WHEN** il tipo è «Suono», «non disturbare» è attivo e il lavoro finisce
- **THEN** l'avviso non emette suono e «Lavoro» diventa comunque scaduto

#### Scenario: Notifica col profilo silenzioso
- **WHEN** il tipo è «Notifica», il telefono è nel profilo silenzioso e il lavoro finisce
- **THEN** l'avviso non emette suono e «Lavoro» diventa comunque scaduto

#### Scenario: Notifica con non disturbare
- **WHEN** il tipo è «Notifica», «non disturbare» è attivo e il lavoro finisce
- **THEN** l'avviso non emette suono e «Lavoro» diventa comunque scaduto

#### Scenario: Sveglia col profilo silenzioso
- **WHEN** il tipo è «Sveglia», il telefono è nel profilo silenzioso e il lavoro finisce
- **THEN** l'avviso è udibile

#### Scenario: Volume della sveglia di sistema
- **WHEN** il tipo è «Sveglia», l'utente abbassa il volume della sveglia nelle impostazioni di sistema e il lavoro finisce
- **THEN** l'avviso suona con la suoneria della sveglia, al volume più basso

#### Scenario: Tipo conservato
- **WHEN** l'utente sceglie «Notifica», chiude l'app e la riapre
- **THEN** il tipo di avviso è «Notifica»

## ADDED Requirements

### Requirement: Banner dell'avviso

Ogni avviso SHALL mostrare un banner col messaggio della fase finita. Con «Suono» e «Sveglia» il banner SHALL comparire una sola volta per avviso, anche con la ripetizione «In loop». Con «Notifica» il suono è parte della notifica di sistema, quindi in loop il banner SHALL ricomparire a ogni ripetizione del suono.

#### Scenario: Un solo banner in loop
- **WHEN** il tipo è «Suono», la ripetizione è «In loop», il lavoro finisce e l'utente preme «Stop» dopo 30 secondi
- **THEN** il suono si ripete per quei 30 secondi e il banner compare una sola volta

#### Scenario: Banner ripetuto con Notifica
- **WHEN** il tipo è «Notifica», la ripetizione è «In loop» e il lavoro finisce
- **THEN** il banner ricompare a ogni ripetizione del suono
