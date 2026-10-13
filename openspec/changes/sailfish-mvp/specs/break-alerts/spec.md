# Spec Delta

## Purpose

Avvisare l'utente alla fine di ogni fase del ciclo 20-20-20, anche a schermo spento, lasciandogli scegliere quanto deve essere invadente l'avviso: una volta o in loop, come sveglia o come notifica.

## ADDED Requirements

### Requirement: Avviso alla fine di ogni fase

Quando lo stato diventa «Lavoro finito» o «Pausa finita» (vedi `break-cycle`), l'app SHALL emettere un avviso sonoro accompagnato da vibrazione, se il dispositivo e il profilo la consentono. L'avviso SHALL partire entro 5 secondi dallo scadere della fase, anche con lo schermo spento o con l'app ridotta a icona, purché l'app sia aperta.

#### Scenario: Schermo spento durante il lavoro
- **WHEN** l'utente avvia il lavoro, riduce l'app a icona e spegne lo schermo
- **THEN** l'avviso parte entro 5 secondi dallo scadere della durata di lavoro

#### Scenario: Fine della pausa
- **WHEN** il conto alla rovescia della pausa arriva a zero mentre l'utente guarda lontano
- **THEN** parte l'avviso, riconoscibile senza guardare lo schermo

### Requirement: Ripetizione dell'avviso

L'utente SHALL poter scegliere la ripetizione dell'avviso tra «Una volta» (predefinita) e «In loop». Con «Una volta» il suono SHALL essere riprodotto una sola volta. Con «In loop» il suono SHALL ripetersi finché l'utente preme il pulsante principale o «Stop». In entrambi i casi lo stato resta in attesa della conferma. La scelta SHALL restare salvata anche dopo la chiusura dell'app.

#### Scenario: Una volta
- **WHEN** la ripetizione è «Una volta» e il lavoro finisce
- **THEN** il suono viene riprodotto una sola volta e lo stato resta «Lavoro finito»

#### Scenario: In loop fino alla conferma
- **WHEN** la ripetizione è «In loop», il lavoro finisce e l'utente preme «Inizia pausa» dopo 30 secondi
- **THEN** il suono si ripete per quei 30 secondi e si interrompe alla pressione

### Requirement: Tipo di avviso

L'utente SHALL poter scegliere il tipo di avviso tra «Notifica» (predefinito) e «Sveglia». Con «Notifica» l'avviso SHALL rispettare il profilo audio del dispositivo: col profilo silenzioso non emette suono. Con «Sveglia» l'avviso SHALL essere udibile anche col profilo silenzioso, come la sveglia di sistema. La scelta SHALL restare salvata anche dopo la chiusura dell'app.

#### Scenario: Notifica col profilo silenzioso
- **WHEN** il tipo è «Notifica», il telefono è nel profilo silenzioso e il lavoro finisce
- **THEN** l'avviso non emette suono e lo stato diventa comunque «Lavoro finito»

#### Scenario: Sveglia col profilo silenzioso
- **WHEN** il tipo è «Sveglia», il telefono è nel profilo silenzioso e il lavoro finisce
- **THEN** l'avviso è udibile

### Requirement: Volume della sveglia

Con il tipo «Sveglia» l'utente SHALL poter impostare il volume dell'avviso dall'app, in percentuale da 5% a 100% a passi di 5 (predefinito 100%), perché il sistema non permette a un'app con sandbox di seguire il volume della sveglia di sistema. Il volume SHALL valere anche col profilo silenzioso e SHALL restare salvato dopo la chiusura dell'app. Con il tipo «Notifica» il volume resta quello della suoneria di sistema.

#### Scenario: Volume ridotto
- **WHEN** il tipo è «Sveglia», il volume è impostato al 30% e il lavoro finisce
- **THEN** la sveglia suona a volume chiaramente più basso che al 100%

#### Scenario: Volume conservato
- **WHEN** l'utente imposta il volume della sveglia al 50%, chiude l'app e la riapre
- **THEN** il volume della sveglia è 50%

### Requirement: Fine dell'avviso

Ogni avviso in corso SHALL interrompersi quando l'utente preme il pulsante principale o «Stop». Un avviso MUST NOT continuare dopo che lo stato è cambiato.

#### Scenario: Conferma durante il loop
- **WHEN** l'avviso è in loop in «Pausa finita» e l'utente preme «Riprendi»
- **THEN** il suono si interrompe subito e parte il lavoro
