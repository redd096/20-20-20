# Spec Delta

## MODIFIED Requirements

### Requirement: Fase di pausa

Premendo «Inizia pausa» in «In attesa della pausa», l'app SHALL passare a «Pausa» in corso e avviare un conto alla rovescia lungo quanto la durata di pausa configurata, oppure quanto la pausa lunga quando la modalità Pomodoro la richiede (vedi `pomodoro`). Allo scadere «Pausa» SHALL diventare scaduta e l'app SHALL far partire l'avviso. Il lavoro successivo MUST NOT partire senza una conferma dell'utente.

#### Scenario: Inizio della pausa
- **WHEN** lo stato è «In attesa della pausa» e l'utente preme «Inizia pausa»
- **THEN** lo stato diventa «Pausa» in corso con un conto alla rovescia pari alla durata di pausa

#### Scenario: Fine della pausa
- **WHEN** il conto alla rovescia della pausa arriva a zero
- **THEN** lo stato resta «Pausa», ora scaduta, parte l'avviso e l'unico comando disponibile è «Stop»

### Requirement: Predefiniti per modalità

I predefiniti per modalità SHALL essere 20 min / 20 s per «Minuti e secondi», 25 min / 5 min per «Minuti e minuti» e 20 s / 20 s per «Secondi e secondi». La pausa lunga della modalità Pomodoro SHALL avere come predefinito 15 min quando la pausa è in minuti e 60 s quando la pausa è in secondi. Scegliendo una modalità diversa da quella attiva, tutte le durate, pausa lunga compresa, SHALL tornare ai predefiniti della nuova modalità.

#### Scenario: Predefiniti di Secondi e secondi
- **WHEN** la modalità è «Minuti e minuti» e l'utente sceglie «Secondi e secondi»
- **THEN** il lavoro dura 20 secondi e la pausa 20 secondi

#### Scenario: Pausa lunga al cambio di modalità
- **WHEN** la modalità è «Minuti e secondi», la pausa lunga è 90 s e l'utente sceglie «Minuti e minuti»
- **THEN** la pausa lunga dura 15 minuti
