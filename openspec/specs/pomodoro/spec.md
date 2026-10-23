# pomodoro Specification

## Purpose
Modalità facoltativa in stile Pomodoro: conta i lavori finiti e, ogni tot lavori, rende più lunga la pausa successiva, senza cambiare l'uso 20-20-20 quando è spenta.

## Requirements

### Requirement: Modalità Pomodoro

Le impostazioni SHALL avere, dopo tutte le altre sezioni, una sezione «Pomodoro» con l'interruttore «Pomodoro timer» (predefinito: spento). Con l'interruttore acceso SHALL comparire due cursori: «Pausa lunga dopo», da 1 a 10 lavori (predefinito 3), e «Pausa lunga», nella stessa unità della pausa normale e con gli stessi intervalli (vedi `break-cycle`). Interruttore e valori SHALL restare salvati anche dopo la chiusura dell'app.

#### Scenario: Modalità spenta
- **WHEN** l'interruttore è spento
- **THEN** i cursori della pausa lunga non sono visibili, la pagina principale non mostra il contatore e ogni pausa dura quanto la pausa normale

#### Scenario: Valori conservati
- **WHEN** l'utente accende l'interruttore, imposta la pausa lunga dopo 4 lavori, chiude l'app e la riapre
- **THEN** l'interruttore è acceso e la pausa lunga arriva dopo 4 lavori

### Requirement: Contatore dei lavori

L'app SHALL contare ogni lavoro finito, sia arrivato a zero sia chiuso con «Stop». «Riavvia lavoro» MUST NOT aggiungere lavori oltre a quello già contato. Con la modalità Pomodoro accesa, la pagina principale SHALL mostrare in basso il contatore con la sua etichetta, nel formato «Lavori fatti: n/N» e il menu a tendina SHALL offrire «Azzera contatore». Il contatore MUST NOT essere salvato: riparte da zero a ogni apertura dell'app.

#### Scenario: Lavoro chiuso con Stop
- **WHEN** la pausa lunga è dopo 3 lavori, il contatore è 0/3 e l'utente preme «Stop» durante il lavoro
- **THEN** il contatore diventa 1/3

#### Scenario: Riavvia lavoro
- **WHEN** il contatore è 1/3, lo stato è «In attesa della pausa» e l'utente preme «Riavvia lavoro»
- **THEN** il contatore resta 1/3 finché il nuovo lavoro non finisce

#### Scenario: Azzera contatore
- **WHEN** il contatore è 2/3 e l'utente sceglie «Azzera contatore»
- **THEN** il contatore diventa 0/3

#### Scenario: Riapertura dell'app
- **WHEN** il contatore è 2/3 e l'utente chiude e riapre l'app
- **THEN** il contatore è 0/3

### Requirement: Pausa lunga

Con la modalità Pomodoro accesa, quando il contatore ha raggiunto il numero di lavori impostato, la pausa avviata dopo SHALL durare quanto la pausa lunga e la pagina principale SHALL mostrarne lo stato come «Pausa lunga». All'avvio della pausa lunga il contatore SHALL tornare a zero. Avviso e notifica SHALL restare quelli della pausa normale.

#### Scenario: Pausa lunga dopo tre lavori
- **WHEN** la pausa lunga è di 15 minuti dopo 3 lavori, il contatore è 3/3 e l'utente preme «Inizia pausa»
- **THEN** lo stato è «Pausa lunga» con un conto alla rovescia di 15 minuti e il contatore è 0/3

#### Scenario: Pausa normale prima del numero impostato
- **WHEN** la pausa lunga è dopo 3 lavori, il contatore è 2/3 e l'utente preme «Inizia pausa»
- **THEN** la pausa dura quanto la pausa normale e il contatore resta 2/3
