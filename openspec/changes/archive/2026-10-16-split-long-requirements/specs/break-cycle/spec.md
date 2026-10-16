# Spec Delta

## MODIFIED Requirements

### Requirement: Stati del ciclo

L'app SHALL trovarsi sempre in uno di questi stati: «In attesa del lavoro», «Lavoro», «In attesa della pausa», «Pausa». «Lavoro» e «Pausa» hanno due momenti: «in corso», mentre scorre il conto alla rovescia, e «scaduto», dopo che il conto alla rovescia è arrivato a zero. All'avvio dell'app lo stato SHALL essere «In attesa del lavoro». I comandi di ogni stato sono in «Comandi per stato».

#### Scenario: Avvio dell'app
- **WHEN** l'utente apre l'app
- **THEN** lo stato è «In attesa del lavoro» e il pulsante principale mostra «Avvia»

### Requirement: Durate configurabili

L'utente SHALL poter scegliere una modalità delle unità tra «Minuti e secondi» (lavoro in minuti, pausa in secondi; predefinita), «Minuti e minuti» e «Secondi e secondi». Modalità e durate SHALL restare salvate anche dopo la chiusura dell'app. Una modifica fatta mentre una fase è in corso SHALL valere dalla fase successiva, senza alterare quella in corso. Intervalli e predefiniti sono in «Intervalli delle durate» e «Predefiniti per modalità».

#### Scenario: Valori predefiniti
- **WHEN** l'utente apre l'app per la prima volta
- **THEN** la modalità è «Minuti e secondi», la durata di lavoro è 20 minuti e quella di pausa è 20 secondi

#### Scenario: Impostazioni conservate
- **WHEN** l'utente imposta il lavoro a 25 minuti, chiude l'app e la riapre
- **THEN** la durata di lavoro è 25 minuti

#### Scenario: Intervalli in minuti
- **WHEN** la modalità è «Minuti e minuti»
- **THEN** lavoro e pausa si impostano da 1 a 60 minuti, a passi di 1 minuto

#### Scenario: Intervalli in secondi
- **WHEN** la modalità è «Secondi e secondi»
- **THEN** lavoro e pausa si impostano da 5 a 120 secondi, a passi di 5 secondi

#### Scenario: Cambio di modalità
- **WHEN** la modalità è «Minuti e secondi» con lavoro a 30 minuti e l'utente sceglie «Minuti e minuti»
- **THEN** il lavoro dura 25 minuti e la pausa 5 minuti, e le impostazioni lo mostrano subito

#### Scenario: Riselezione della modalità attiva
- **WHEN** la modalità è «Minuti e secondi» con lavoro a 30 minuti e l'utente sceglie di nuovo «Minuti e secondi»
- **THEN** le durate restano invariate

#### Scenario: Modifica durante una fase
- **WHEN** lo stato è «Lavoro» in corso con 10 minuti rimanenti e l'utente cambia la durata di lavoro a 30 minuti
- **THEN** la fase in corso finisce comunque dopo 10 minuti e il lavoro successivo dura 30 minuti

#### Scenario: Cambio di modalità durante una fase
- **WHEN** lo stato è «Lavoro» in corso con 10 minuti rimanenti e l'utente sceglie «Secondi e secondi»
- **THEN** la fase in corso finisce comunque dopo 10 minuti e il lavoro successivo dura 20 secondi

### Requirement: Fase di lavoro

Premendo «Avvia» in «In attesa del lavoro», o «Riavvia lavoro» in «In attesa della pausa», l'app SHALL passare a «Lavoro» in corso e avviare un conto alla rovescia lungo quanto la durata di lavoro configurata. Allo scadere «Lavoro» SHALL diventare scaduto e l'app SHALL far partire l'avviso (vedi `break-alerts`). La fase di pausa MUST NOT partire senza una conferma dell'utente.

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
- **WHEN** lo stato è «In attesa della pausa» e l'utente preme «Riavvia lavoro»
- **THEN** lo stato diventa «Lavoro» in corso con un nuovo conto alla rovescia pari alla durata di lavoro

## ADDED Requirements

### Requirement: Comandi per stato

L'app SHALL mostrare in modo evidente lo stato corrente e solo questi comandi, con un pulsante principale ben visibile:

- «In attesa del lavoro»: «Avvia».
- «Lavoro» e «Pausa», in corso o scaduti: solo «Stop».
- «In attesa della pausa»: «Inizia pausa» come pulsante principale e «Riavvia lavoro».

#### Scenario: Comandi durante una fase
- **WHEN** lo stato è «Lavoro» in corso
- **THEN** l'unico comando mostrato è «Stop»

#### Scenario: Comandi in attesa della pausa
- **WHEN** lo stato è «In attesa della pausa»
- **THEN** il pulsante principale è «Inizia pausa» e l'altro comando è «Riavvia lavoro»

### Requirement: Intervalli delle durate

Ogni durata espressa in minuti SHALL andare da 1 a 60 con passo 1, ogni durata espressa in secondi da 5 a 120 con passo 5, in qualsiasi modalità delle unità.

#### Scenario: Unità diverse per lavoro e pausa
- **WHEN** la modalità è «Minuti e secondi»
- **THEN** il lavoro si imposta da 1 a 60 minuti a passi di 1 minuto e la pausa da 5 a 120 secondi a passi di 5 secondi

### Requirement: Predefiniti per modalità

I predefiniti per modalità SHALL essere 20 min / 20 s per «Minuti e secondi», 25 min / 5 min per «Minuti e minuti» e 20 s / 20 s per «Secondi e secondi». Scegliendo una modalità diversa da quella attiva, entrambe le durate SHALL tornare ai predefiniti della nuova modalità.

#### Scenario: Predefiniti di Secondi e secondi
- **WHEN** la modalità è «Minuti e minuti» e l'utente sceglie «Secondi e secondi»
- **THEN** il lavoro dura 20 secondi e la pausa 20 secondi
