# Spec Delta

## MODIFIED Requirements

### Requirement: Tipo di avviso

L'utente SHALL poter scegliere il tipo di avviso tra «Suono» (predefinito), «Notifica» e «Sveglia». Con «Suono» l'avviso SHALL seguire il volume delle applicazioni, con «Notifica» quello della suoneria, con «Sveglia» la suoneria e il volume della sveglia di sistema scelti dall'utente. La scelta SHALL restare salvata anche dopo la chiusura dell'app. Il comportamento col profilo silenzioso e con «non disturbare» è in «Profilo silenzioso e non disturbare».

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

### Requirement: Profilo silenzioso e non disturbare

Con «Suono» e «Notifica» l'avviso SHALL essere muto col profilo silenzioso e con «non disturbare». Con «Sveglia» l'avviso SHALL essere udibile anche col profilo silenzioso.

#### Scenario: Silenzioso e non disturbare insieme
- **WHEN** il tipo è «Suono», il telefono è nel profilo silenzioso, «non disturbare» è attivo e il lavoro finisce
- **THEN** l'avviso non emette suono e «Lavoro» diventa comunque scaduto
