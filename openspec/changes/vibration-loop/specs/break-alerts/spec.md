# Spec Delta

## ADDED Requirements

### Requirement: Vibrazione in loop

Con la ripetizione «In loop» e il tipo «Suono» o «Notifica», l'utente SHALL poter scegliere se la vibrazione si ripete a ogni giro dell'avviso (predefinito: no). Se sì, la vibrazione SHALL ripetersi a ogni giro fino allo «Stop», anche col profilo silenzioso e con «non disturbare», quando il suono è muto. Se no, la vibrazione SHALL avvenire solo all'inizio dell'avviso. La scelta SHALL restare salvata anche dopo la chiusura dell'app.

#### Scenario: Vibrazione solo all'inizio
- **WHEN** l'interruttore è spento, la ripetizione è «In loop» e il lavoro finisce
- **THEN** il telefono vibra solo all'inizio dell'avviso, mentre il suono si ripete

#### Scenario: Vibrazione a ogni giro
- **WHEN** l'interruttore è acceso, la ripetizione è «In loop», il lavoro finisce e l'utente preme «Stop» dopo 30 secondi
- **THEN** il telefono vibra a ogni ripetizione del suono per quei 30 secondi e smette alla pressione

#### Scenario: Solo vibrazione col profilo silenzioso
- **WHEN** l'interruttore è acceso, il tipo è «Suono», la ripetizione è «In loop», il telefono è nel profilo silenzioso e il lavoro finisce
- **THEN** l'avviso non emette suono ma il telefono vibra a ogni giro fino allo «Stop»

#### Scenario: Interruttore conservato
- **WHEN** l'utente accende l'interruttore, chiude l'app e la riapre
- **THEN** l'interruttore è acceso
