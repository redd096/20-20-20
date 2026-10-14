# Spec Delta

## Purpose

Avvisare l'utente alla fine di ogni fase del ciclo 20-20-20, anche a schermo spento, lasciandogli scegliere quanto deve essere invadente l'avviso: una volta o in loop, come sveglia o come notifica.

## ADDED Requirements

### Requirement: Avviso alla fine di ogni fase

Quando «Lavoro» o «Pausa» diventano scaduti (vedi `break-cycle`), l'app SHALL emettere un avviso sonoro accompagnato da vibrazione, se il dispositivo e il profilo la consentono. L'avviso SHALL partire entro 5 secondi dallo scadere della fase, anche con lo schermo spento o con l'app ridotta a icona, purché l'app sia aperta.

#### Scenario: Schermo spento durante il lavoro
- **WHEN** l'utente avvia il lavoro, riduce l'app a icona e spegne lo schermo
- **THEN** l'avviso parte entro 5 secondi dallo scadere della durata di lavoro

#### Scenario: Fine della pausa
- **WHEN** il conto alla rovescia della pausa arriva a zero mentre l'utente guarda lontano
- **THEN** parte l'avviso, riconoscibile senza guardare lo schermo

### Requirement: Ripetizione dell'avviso

L'utente SHALL poter scegliere la ripetizione dell'avviso tra «Una volta» (predefinita) e «In loop». Con «Una volta» il suono SHALL essere riprodotto una sola volta (con «Sveglia», per la durata impostata: vedi «Durata della sveglia»). Con «In loop» il suono SHALL ripetersi finché l'utente preme «Stop». In entrambi i casi lo stato resta scaduto finché l'utente preme «Stop». La scelta SHALL restare salvata anche dopo la chiusura dell'app.

#### Scenario: Una volta
- **WHEN** la ripetizione è «Una volta» e il lavoro finisce
- **THEN** il suono viene riprodotto una sola volta e lo stato resta «Lavoro» scaduto

#### Scenario: In loop fino allo Stop
- **WHEN** la ripetizione è «In loop», il lavoro finisce e l'utente preme «Stop» dopo 30 secondi
- **THEN** il suono si ripete per quei 30 secondi e si interrompe alla pressione

### Requirement: Tipo di avviso

L'utente SHALL poter scegliere il tipo di avviso tra «Notifica» (predefinito) e «Sveglia». Con «Notifica» l'avviso SHALL rispettare il profilo audio del dispositivo: col profilo silenzioso non emette suono. Con «Sveglia» l'avviso SHALL usare la sveglia di sistema, con la suoneria e il volume della sveglia scelti dall'utente, e SHALL essere udibile anche col profilo silenzioso. La scelta SHALL restare salvata anche dopo la chiusura dell'app.

#### Scenario: Notifica col profilo silenzioso
- **WHEN** il tipo è «Notifica», il telefono è nel profilo silenzioso e il lavoro finisce
- **THEN** l'avviso non emette suono e «Lavoro» diventa comunque scaduto

#### Scenario: Sveglia col profilo silenzioso
- **WHEN** il tipo è «Sveglia», il telefono è nel profilo silenzioso e il lavoro finisce
- **THEN** l'avviso è udibile

#### Scenario: Volume della sveglia di sistema
- **WHEN** il tipo è «Sveglia», l'utente abbassa il volume della sveglia nelle impostazioni di sistema e il lavoro finisce
- **THEN** l'avviso suona con la suoneria della sveglia, al volume più basso

### Requirement: Durata della sveglia

La sveglia di sistema si ripete finché non viene fermata e sale di volume nei primi 20 secondi. Con il tipo «Sveglia» e la ripetizione «Una volta», l'utente SHALL poter impostare per quanti secondi suona, da 5 a 60 a passi di 5 (predefinito 30); allo scadere il suono SHALL fermarsi mentre lo stato resta scaduto finché l'utente preme «Stop». La scelta SHALL restare salvata dopo la chiusura dell'app.

#### Scenario: Sveglia una volta
- **WHEN** il tipo è «Sveglia», la ripetizione è «Una volta», la durata è 30 secondi e il lavoro finisce
- **THEN** la sveglia suona per circa 30 secondi e poi tace, e lo stato resta «Lavoro» scaduto

#### Scenario: Durata conservata
- **WHEN** l'utente imposta la durata della sveglia a 15 secondi, chiude l'app e la riapre
- **THEN** la durata della sveglia è 15 secondi

### Requirement: Fine dell'avviso

Ogni avviso in corso SHALL interrompersi quando l'utente preme «Stop». Un avviso MUST NOT continuare dopo che lo stato è cambiato.

#### Scenario: Stop durante il loop
- **WHEN** l'avviso è in loop in «Pausa» scaduta e l'utente preme «Stop»
- **THEN** il suono si interrompe subito e lo stato diventa «In attesa del lavoro»
