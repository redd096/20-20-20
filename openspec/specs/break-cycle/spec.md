# break-cycle Specification

## Purpose

Scandire la regola 20-20-20 con un ciclo di due fasi, lavoro e pausa, avviato da un solo pulsante e portato avanti da una conferma manuale dell'utente a ogni passaggio. Il comportamento è lo stesso su tutte le piattaforme.

## Requirements

### Requirement: Stati del ciclo

L'app SHALL trovarsi sempre in uno di questi stati: «In attesa del lavoro», «Lavoro», «In attesa della pausa», «Pausa». «Lavoro» e «Pausa» hanno due momenti: «in corso», mentre scorre il conto alla rovescia, e «scaduto», dopo che il conto alla rovescia è arrivato a zero. All'avvio dell'app lo stato SHALL essere «In attesa del lavoro». L'app SHALL mostrare in modo evidente lo stato corrente e solo questi comandi, con un pulsante principale ben visibile:

- «In attesa del lavoro»: «Avvia».
- «Lavoro» e «Pausa», in corso o scaduti: solo «Stop».
- «In attesa della pausa»: «Inizia pausa» come pulsante principale e «Riprendi lavoro».

#### Scenario: Avvio dell'app
- **WHEN** l'utente apre l'app
- **THEN** lo stato è «In attesa del lavoro» e il pulsante principale mostra «Avvia»

### Requirement: Fase di lavoro

Premendo «Avvia» in «In attesa del lavoro», o «Riprendi lavoro» in «In attesa della pausa», l'app SHALL passare a «Lavoro» in corso e avviare un conto alla rovescia lungo quanto la durata di lavoro configurata. Allo scadere «Lavoro» SHALL diventare scaduto e l'app SHALL far partire l'avviso (vedi `break-alerts`). La fase di pausa MUST NOT partire senza una conferma dell'utente.

#### Scenario: Avvio del ciclo
- **WHEN** lo stato è «In attesa del lavoro» e l'utente preme «Avvia»
- **THEN** lo stato diventa «Lavoro» in corso con un conto alla rovescia pari alla durata di lavoro

#### Scenario: Fine del lavoro
- **WHEN** il conto alla rovescia del lavoro arriva a zero
- **THEN** lo stato resta «Lavoro», ora scaduto, parte l'avviso e l'unico comando disponibile è «Stop»

#### Scenario: Nessuna conferma
- **WHEN** «Lavoro» è scaduto e l'utente non preme nulla
- **THEN** l'app resta in «Lavoro» scaduto, il tempo in più continua a crescere e la pausa non parte

#### Scenario: Lavoro rimandato
- **WHEN** lo stato è «In attesa della pausa» e l'utente preme «Riprendi lavoro»
- **THEN** lo stato diventa «Lavoro» in corso con un nuovo conto alla rovescia pari alla durata di lavoro

### Requirement: Fase di pausa

Premendo «Inizia pausa» in «In attesa della pausa», l'app SHALL passare a «Pausa» in corso e avviare un conto alla rovescia lungo quanto la durata di pausa configurata. Allo scadere «Pausa» SHALL diventare scaduta e l'app SHALL far partire l'avviso. Il lavoro successivo MUST NOT partire senza una conferma dell'utente.

#### Scenario: Inizio della pausa
- **WHEN** lo stato è «In attesa della pausa» e l'utente preme «Inizia pausa»
- **THEN** lo stato diventa «Pausa» in corso con un conto alla rovescia pari alla durata di pausa

#### Scenario: Fine della pausa
- **WHEN** il conto alla rovescia della pausa arriva a zero
- **THEN** lo stato resta «Pausa», ora scaduta, parte l'avviso e l'unico comando disponibile è «Stop»

### Requirement: Stop

In «Lavoro» e «Pausa», in corso o scaduti, il comando «Stop» SHALL chiudere la fase corrente: interrompe l'eventuale conto alla rovescia e l'avviso in corso. Da «Lavoro» lo stato SHALL diventare «In attesa della pausa»; da «Pausa» SHALL diventare «In attesa del lavoro». Nei due stati di attesa nessun conto alla rovescia né avviso SHALL essere attivo. Non esiste un comando per azzerare il ciclo: per smettere l'utente chiude l'app.

#### Scenario: Stop dopo la fine del lavoro
- **WHEN** «Lavoro» è scaduto con l'avviso in loop e l'utente preme «Stop»
- **THEN** l'avviso si interrompe, lo stato diventa «In attesa della pausa» e la pausa non parte

#### Scenario: Lavoro finito in anticipo
- **WHEN** lo stato è «Lavoro» in corso con 10 minuti rimanenti e l'utente preme «Stop»
- **THEN** il conto alla rovescia si annulla, nessun avviso parte in seguito e lo stato diventa «In attesa della pausa»

#### Scenario: Stop durante la pausa
- **WHEN** lo stato è «Pausa» in corso e l'utente preme «Stop»
- **THEN** il conto alla rovescia si annulla, nessun avviso parte in seguito e lo stato diventa «In attesa del lavoro»

### Requirement: Tempo rimanente

Durante «Lavoro» e «Pausa» in corso l'app SHALL mostrare il tempo rimanente nel formato minuti:secondi, aggiornato almeno una volta al secondo mentre l'app è visibile. Il tempo rimanente SHALL essere calcolato dall'istante di fine della fase, in modo da restare corretto dopo che lo schermo è stato spento o l'app ridotta a icona.

#### Scenario: Ritorno all'app dopo lo schermo spento
- **WHEN** l'utente avvia il lavoro di 20 minuti, spegne lo schermo e lo riaccende dopo 5 minuti
- **THEN** l'app mostra circa 15:00 rimanenti

### Requirement: Tempo in più

In «Lavoro» e «Pausa» scaduti l'app SHALL mostrare 0:00 al posto del tempo rimanente e, a partire da 10 secondi dopo lo scadere, anche il tempo trascorso dallo scadere, in rosso, nel formato -minuti:secondi, aggiornato almeno una volta al secondo mentre l'app è visibile. Il tempo in più SHALL essere calcolato dall'istante di fine della fase e MUST NOT tenere sveglio il dispositivo.

#### Scenario: Risposta pronta
- **WHEN** «Lavoro» scade e l'utente preme «Stop» entro 5 secondi
- **THEN** il tempo in più non viene mai mostrato

#### Scenario: Ritorno dopo lo schermo spento
- **WHEN** «Lavoro» scade con lo schermo spento e l'utente lo riaccende 2 minuti dopo
- **THEN** l'app mostra 0:00 e un tempo in più di circa -2:00

### Requirement: Durate configurabili

L'utente SHALL poter impostare la durata di lavoro in minuti interi da 1 a 120 (predefinita 20) e la durata di pausa in secondi interi da 5 a 300 (predefinita 20). Le impostazioni SHALL restare salvate anche dopo la chiusura dell'app. Una modifica fatta mentre una fase è in corso SHALL valere dalla fase successiva, senza alterare quella in corso.

#### Scenario: Valori predefiniti
- **WHEN** l'utente apre l'app per la prima volta
- **THEN** la durata di lavoro è 20 minuti e quella di pausa è 20 secondi

#### Scenario: Impostazioni conservate
- **WHEN** l'utente imposta il lavoro a 25 minuti, chiude l'app e la riapre
- **THEN** la durata di lavoro è 25 minuti

#### Scenario: Modifica durante una fase
- **WHEN** lo stato è «Lavoro» in corso con 10 minuti rimanenti e l'utente cambia la durata di lavoro a 30 minuti
- **THEN** la fase in corso finisce comunque dopo 10 minuti e il lavoro successivo dura 30 minuti

### Requirement: Nessuna attività ad app chiusa

Il ciclo SHALL funzionare solo mentre l'app è aperta, in primo piano o ridotta a icona. Chiudendo l'app il ciclo SHALL interrompersi senza lasciare timer, avvisi o processi attivi, e l'app MUST NOT avviarsi automaticamente all'accensione del dispositivo.

#### Scenario: Chiusura durante il lavoro
- **WHEN** lo stato è «Lavoro» in corso e l'utente chiude l'app
- **THEN** allo scadere della durata di lavoro non parte nessun avviso e nessun processo dell'app resta attivo
