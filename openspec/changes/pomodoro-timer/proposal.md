# Proposal

## Why

Chi usa l'app alla Pomodoro (per esempio con «Minuti e minuti», 25/5) vuole una pausa più lunga ogni tot lavori. Oggi tutte le pause durano uguali. Una modalità Pomodoro facoltativa, spenta per impostazione predefinita, aggiunge la pausa lunga senza toccare l'uso 20-20-20.

## What Changes

- Nelle impostazioni, sotto tutte le sezioni attuali e separata da uno spazio, una nuova sezione «Pomodoro» con l'interruttore «Pomodoro timer» (spento per impostazione predefinita).
- Con l'interruttore acceso compaiono due cursori, come in Minidoro:
  - «Pausa lunga dopo N lavori», da 1 a 10;
  - «Durata della pausa lunga», nella stessa unità della pausa normale secondo la modalità delle unità: in minuti da 1 a 60 con passo 1, in secondi da 5 a 120 con passo 5 (le stesse regole degli altri cursori).
- Con la modalità Pomodoro attiva:
  - la pagina principale mostra un contatore dei lavori, vicino al timer e ai pulsanti;
  - quando il contatore ha raggiunto N, la pausa successiva («Inizia pausa») dura quanto la pausa lunga; quando la pausa lunga parte, il contatore torna a zero;
  - nel menu a tendina, oltre a «Impostazioni», compare «Azzera contatore».

### Scelte proposte, da confermare prima del design

- **Cosa conta come lavoro fatto**: un lavoro arrivato a zero (scaduto). Un lavoro chiuso in anticipo con «Stop» non conta; «Riavvia lavoro» non conta il lavoro rimandato.
- **Formato del contatore**: «lavori fatti / N», per esempio «2/3».
- **Valori predefiniti**: pausa lunga dopo 3 lavori (come Minidoro); durata della pausa lunga 15 min con la pausa in minuti, 60 s con la pausa in secondi. Il cambio di modalità delle unità riporta anche la pausa lunga al suo predefinito, come già le altre durate.
- **Contatore non salvato**: riparte da zero a ogni apertura dell'app, come in Minidoro; «Azzera contatore» serve durante una sessione.
- **Nome dello stato**: la pausa lunga si mostra come «Pausa lunga» nella pagina principale; avviso e notifica restano quelli della pausa normale.

Fuori scope: un'icona o un contatore sulla copertina (cover), statistiche o storico dei lavori, testi dell'avviso diversi per la pausa lunga.

## Capabilities

### New Capabilities
- `pomodoro`: modalità facoltativa con contatore dei lavori e pausa lunga.

### Modified Capabilities
- `break-cycle`: «Fase di pausa» usa la durata della pausa lunga quando la modalità Pomodoro la richiede; «Predefiniti per modalità» include la pausa lunga.

## Impact

- `project_sailfish_os/qml/CycleController.qml`: contatore e scelta tra pausa normale e lunga.
- `project_sailfish_os/qml/pages/MainPage.qml`: contatore, stato «Pausa lunga», voce «Azzera contatore».
- `project_sailfish_os/qml/pages/SettingsPage.qml` e `qml/harbour-202020.qml`: nuove chiavi dconf (attivazione, numero di lavori, durata della pausa lunga in secondi) e sezione «Pomodoro».
- `docs/sailfish.md`, `docs/acceptance-checklist.md`, traduzioni.
- Nessuna nuova dipendenza o permesso.
