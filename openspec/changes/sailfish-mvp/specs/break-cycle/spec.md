# Spec Delta

## Purpose

Scandire la regola 20-20-20 con un ciclo di due fasi, lavoro e pausa, avviato da un solo pulsante e portato avanti da una conferma manuale dell'utente a ogni passaggio. Il comportamento è lo stesso su tutte le piattaforme.

## ADDED Requirements

### Requirement: Stati del ciclo

L'app SHALL trovarsi sempre in uno di questi stati: «Fermo», «Lavoro in corso», «Lavoro finito», «Pausa in corso», «Pausa finita». All'avvio dell'app lo stato SHALL essere «Fermo». L'app SHALL mostrare in modo evidente lo stato corrente e un solo pulsante principale, la cui etichetta dipende dallo stato: «Avvia» in «Fermo», «Inizia pausa» in «Lavoro finito», «Riprendi» in «Pausa finita». Durante «Lavoro in corso» e «Pausa in corso» il pulsante principale non è disponibile.

#### Scenario: Avvio dell'app
- **WHEN** l'utente apre l'app
- **THEN** lo stato è «Fermo» e il pulsante principale mostra «Avvia»

### Requirement: Fase di lavoro

Premendo «Avvia» in «Fermo», o «Riprendi» in «Pausa finita», l'app SHALL passare a «Lavoro in corso» e avviare un conto alla rovescia lungo quanto la durata di lavoro configurata. Allo scadere l'app SHALL passare a «Lavoro finito» e far partire l'avviso (vedi `break-alerts`). La fase di pausa MUST NOT partire senza una conferma dell'utente.

#### Scenario: Avvio del ciclo
- **WHEN** lo stato è «Fermo» e l'utente preme «Avvia»
- **THEN** lo stato diventa «Lavoro in corso» con un conto alla rovescia pari alla durata di lavoro

#### Scenario: Fine del lavoro
- **WHEN** il conto alla rovescia del lavoro arriva a zero
- **THEN** lo stato diventa «Lavoro finito», parte l'avviso e il pulsante principale mostra «Inizia pausa»

#### Scenario: Nessuna conferma
- **WHEN** lo stato è «Lavoro finito» e l'utente non preme nulla
- **THEN** l'app resta in «Lavoro finito» senza avviare la pausa

### Requirement: Fase di pausa

Premendo «Inizia pausa» in «Lavoro finito», l'app SHALL interrompere l'eventuale avviso in corso, passare a «Pausa in corso» e avviare un conto alla rovescia lungo quanto la durata di pausa configurata. Allo scadere l'app SHALL passare a «Pausa finita» e far partire l'avviso. Il lavoro successivo MUST NOT partire senza una conferma dell'utente.

#### Scenario: Inizio della pausa
- **WHEN** lo stato è «Lavoro finito» e l'utente preme «Inizia pausa»
- **THEN** l'avviso si interrompe e lo stato diventa «Pausa in corso» con un conto alla rovescia pari alla durata di pausa

#### Scenario: Fine della pausa
- **WHEN** il conto alla rovescia della pausa arriva a zero
- **THEN** lo stato diventa «Pausa finita», parte l'avviso e il pulsante principale mostra «Riprendi»

#### Scenario: Ripresa del lavoro
- **WHEN** lo stato è «Pausa finita» e l'utente preme «Riprendi»
- **THEN** l'avviso si interrompe e lo stato diventa «Lavoro in corso» con un nuovo conto alla rovescia pari alla durata di lavoro

### Requirement: Stop

In ogni stato diverso da «Fermo» l'app SHALL offrire un comando «Stop» che interrompe l'eventuale conto alla rovescia e l'avviso in corso e riporta lo stato a «Fermo».

#### Scenario: Stop durante il lavoro
- **WHEN** lo stato è «Lavoro in corso» e l'utente preme «Stop»
- **THEN** il conto alla rovescia si annulla, nessun avviso parte in seguito e lo stato diventa «Fermo»

#### Scenario: Stop durante un avviso
- **WHEN** lo stato è «Lavoro finito» con l'avviso in loop e l'utente preme «Stop»
- **THEN** l'avviso si interrompe e lo stato diventa «Fermo»

### Requirement: Tempo rimanente

Durante «Lavoro in corso» e «Pausa in corso» l'app SHALL mostrare il tempo rimanente nel formato minuti:secondi, aggiornato almeno una volta al secondo mentre l'app è visibile. Il tempo rimanente SHALL essere calcolato dall'istante di fine della fase, in modo da restare corretto dopo che lo schermo è stato spento o l'app ridotta a icona.

#### Scenario: Ritorno all'app dopo lo schermo spento
- **WHEN** l'utente avvia il lavoro di 20 minuti, spegne lo schermo e lo riaccende dopo 5 minuti
- **THEN** l'app mostra circa 15:00 rimanenti

### Requirement: Durate configurabili

L'utente SHALL poter impostare la durata di lavoro in minuti interi da 1 a 120 (predefinita 20) e la durata di pausa in secondi interi da 5 a 300 (predefinita 20). Le impostazioni SHALL restare salvate anche dopo la chiusura dell'app. Una modifica fatta mentre una fase è in corso SHALL valere dalla fase successiva, senza alterare quella in corso.

#### Scenario: Valori predefiniti
- **WHEN** l'utente apre l'app per la prima volta
- **THEN** la durata di lavoro è 20 minuti e quella di pausa è 20 secondi

#### Scenario: Impostazioni conservate
- **WHEN** l'utente imposta il lavoro a 25 minuti, chiude l'app e la riapre
- **THEN** la durata di lavoro è 25 minuti

#### Scenario: Modifica durante una fase
- **WHEN** lo stato è «Lavoro in corso» con 10 minuti rimanenti e l'utente cambia la durata di lavoro a 30 minuti
- **THEN** la fase in corso finisce comunque dopo 10 minuti e il lavoro successivo dura 30 minuti

### Requirement: Nessuna attività ad app chiusa

Il ciclo SHALL funzionare solo mentre l'app è aperta, in primo piano o ridotta a icona. Chiudendo l'app il ciclo SHALL interrompersi senza lasciare timer, avvisi o processi attivi, e l'app MUST NOT avviarsi automaticamente all'accensione del dispositivo.

#### Scenario: Chiusura durante il lavoro
- **WHEN** lo stato è «Lavoro in corso» e l'utente chiude l'app
- **THEN** allo scadere della durata di lavoro non parte nessun avviso e nessun processo dell'app resta attivo
