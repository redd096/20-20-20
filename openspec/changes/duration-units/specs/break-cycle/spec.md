# Spec Delta

## MODIFIED Requirements

### Requirement: Durate configurabili

L'utente SHALL poter scegliere una modalità delle unità tra «Minuti e secondi» (lavoro in minuti, pausa in secondi; predefinita), «Minuti e minuti» e «Secondi e secondi». Ogni durata espressa in minuti SHALL andare da 1 a 60 con passo 1, ogni durata in secondi da 5 a 120 con passo 5. I predefiniti per modalità SHALL essere 20 min / 20 s, 25 min / 5 min e 20 s / 20 s. Scegliendo una modalità diversa da quella attiva, entrambe le durate SHALL tornare ai predefiniti della nuova modalità. Modalità e durate SHALL restare salvate anche dopo la chiusura dell'app. Una modifica fatta mentre una fase è in corso SHALL valere dalla fase successiva, senza alterare quella in corso.

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
