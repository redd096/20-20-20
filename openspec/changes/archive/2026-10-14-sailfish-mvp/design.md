# Design

## Context

Il progetto parte da zero: in `app_20_20_20/` ci sono solo `openspec/` e `.claude/`. Sul PC sono già pronti `~/SailfishOS/bin/sfdk`, usato in `keyboard_jolla` col target `SailfishOS-5.1.0.11-aarch64` e con Docker avviato a mano solo per la build, e la configurazione ssh del telefono in `../keyboard_jolla/ssh/jolla.conf`. Il telefono è un Jolla Phone 2026 con Sailfish OS 5.2. Il riferimento per il funzionamento in background è Fernschreiber: niente daemon, l'app lavora finché è aperta o ridotta a icona.

Il vincolo tecnico principale è che a schermo spento Sailfish sospende la CPU, e un `Timer` QML da solo si ferma. Il secondo è che il Jolla Store (Harbour) ammette solo un elenco ristretto di import QML e librerie.

## Goals / Non-Goals

**Goals:**
- Un'app QML/Silica minima che soddisfi `break-cycle` e `break-alerts`, costruita con `sfdk` senza installare nulla di nuovo sul PC.
- Restare dentro le regole Harbour, per poter pubblicare sia nel Jolla Store sia su OpenRepos.
- Una logica del ciclo semplice da portare poi su Android.

**Non-Goals:**
- Azioni sulla cover o dalle notifiche. La cover di sistema mostra solo stato e tempo rimanente, senza pulsanti.
- Componenti C++ oltre al launcher standard `sailfishapp`.
- Test automatici QML: la verifica avviene sul telefono con durate brevi (vedi tasks).

## Decisions

### D1. Repository git alla radice `app_20_20_20/`
`openspec/`, `docs/`, `project_sailfish_os/` e, più avanti, `project_android/` stanno nello stesso repo. Il `.gitignore` esclude `.claude/`, `build/` e `ssh/`.
- *Perché*: il CLI `openspec` cerca la cartella `openspec/` salendo dalla cartella corrente, e la spec va versionata col codice.
- *Alternativa scartata*: repo in una sottocartella, che lascerebbe `openspec/` fuori dal versionamento.

### D2. Struttura del progetto Sailfish
Template standard `sailfishapp`, come per `reddo-keyboard`:
```
project_sailfish_os/
  harbour-202020.pro   harbour-202020.desktop
  src/harbour-202020.cpp
  qml/harbour-202020.qml        (ApplicationWindow + CycleController)
  qml/CycleController.qml       (stati, timer, avvisi)
  qml/pages/MainPage.qml        (stato, tempo, pulsante, Stop)
  qml/pages/SettingsPage.qml
  qml/cover/CoverPage.qml       (passiva)
  rpm/harbour-202020.spec   translations/   icons/
```
Le build escono in `build/sailfish/`, ignorata da git.

### D3. Logica del ciclo in un solo oggetto QML
`CycleController` contiene la fase corrente, l'istante di fine fase `endTime` (ms epoch) e le funzioni `confirm()`, `restartWork()` e `stop()`. Le pagine leggono solo le sue proprietà.
- Le fasi interne sono 6: `waitWork`, `working`, `workDone`, `waitBreak`, `onBreak`, `breakDone`. La pagina raggruppa `working` e `workDone` nello stato «Lavoro» di `break-cycle` (in corso / scaduto), e `onBreak` e `breakDone` in «Pausa».
- `confirm()` è il pulsante principale delle attese: da `waitWork` porta a `working`, da `waitBreak` a `onBreak`. `restartWork()` porta da `waitBreak` a `working`. `stop()` chiude la fase: da `working`/`workDone` porta a `waitBreak`, da `onBreak`/`breakDone` a `waitWork`.
- Il tempo rimanente si calcola come `endTime - Date.now()`, mai contando i tick. Così resta corretto dopo un suspend o un ritardo.
- `endTime` resta impostato anche dopo lo scadere: il tempo in più è `Date.now() - endTime`, quindi è corretto anche dopo che lo schermo è rimasto spento.
- Un `Timer` da 1 s aggiorna la UI, sia durante il conto alla rovescia sia nelle fasi scadute. Lo scadere viene controllato a ogni tick e da un secondo `Timer` mono-colpo impostato sul tempo rimanente. `KeepAlive` resta legato solo al conto alla rovescia (e al loop dell'avviso, vedi D4): il tempo in più si aggiorna solo quando l'app è visibile.
- *Perché*: un solo punto di verità, facile da tradurre in Kotlin. La visualizzazione del tempo in più (0:00 fisso più un `-m:ss` rosso dopo 10 s) è ispirata a Minidoro (GPL-3.0), che però lo conta sommando i tick e a schermo spento resta indietro. *Alternativa scartata*: logica in C++, che con questa dimensione aggiungerebbe solo complessità.

### D4. Tenere sveglio il telefono con `Nemo.KeepAlive`
`KeepAlive { enabled: ... }` è attivo solo mentre una fase è in corso o un avviso è in loop. Impedisce il suspend della CPU ma non tiene acceso lo schermo. All'uscita dell'app il processo termina e il blocco viene rilasciato, quindi non resta nulla attivo.
- *Alternative scartate*:
  - `BackgroundJob`: si sveglia solo a intervalli fissi (30 s, 2,5 min, ...), troppo imprecisi per il limite di 5 s.
  - Allarmi di sistema `timed`: lasciano voci nel daemon di sistema anche ad app chiusa (contro `break-cycle`) e non sono ammessi in Harbour.
- *Confermato dallo spike*: l'import è ammesso da `sfdk check`, l'avviso arriva con 0 s di ritardo a schermo spento e 20 minuti costano circa l'1% di batteria (`docs/sailfish-spike.md`).

### D5. Suono: due percorsi, verificati con lo spike
Esiti completi in `docs/sailfish-spike.md`.
- «Notifica»: una `Notification` (`Nemo.Notifications`) con urgenza critica e `sound` su un suono di sistema. La riproduce il sistema (lipstick), sul volume Suoneria, rispettando silenzioso e «non disturbare». Accende lo schermo e lascia una sola voce negli Eventi, sostituita dall'avviso successivo. Come per tutte le app, la voce resta finché l'utente non la toglie. Toccarla non apre l'app: servirebbe un'azione D-Bus, rimandata insieme ai comandi da notifica.
- «Sveglia»: la stessa notifica critica, ma senza suono (accende lo schermo e mostra il messaggio), più l'evento `clock` del demone `ngfd`, chiamato via D-Bus di sistema con `Nemo.DBus 2.0` (`Play(s, a{sv})` sull'interfaccia `com.nokia.NonGraphicFeedback1`, poi `Stop(u)`). È la sveglia di sistema: suoneria e volume della sveglia dell'utente, vibrazione «alarm», suona anche col silenzioso e col «non disturbare». `ngfd` annulla gli eventi di un client che si disconnette e lascia fermarli solo a chi li ha avviati: la connessione è quella dell'app, aperta finché l'app gira.
- L'evento `clock` sale di volume in 20 s e si ripete da solo. In loop l'app lo lascia suonare fino alla conferma; con «Una volta» lo ferma dopo `alarmOnceSeconds` (5–60 s, predefinito 30). `ngfd` non lascia cambiare ripetizione e fade-in (solo le chiavi elencate in `50-transform.ini`).
- La vibrazione della «Notifica» usa `HapticsEffect` (`QtFeedback 5.0`); la «Sveglia» usa quella dell'evento `ngfd`.
- Il loop della «Notifica» è un `Timer` che ripubblica la notifica finché lo stato è «finito» e la ripetizione è «In loop».
- I suoni della «Notifica» sono file di sistema in `/usr/share/sounds/jolla-ringtones/stereo/`, senza file audio nel pacchetto.
- *Alternative scartate*: `Nemo.Ngf`, non ammesso in Harbour; hint `x-nemo-feedback`, che non si può impostare da QML (`setHintValue()` non esiste); `Audio` di `QtMultimedia` con `PULSE_PROP=media.role=alarm` nel launcher, usato fino alla release 12, che suona col silenzioso ma sempre a volume massimo e con un suono fisso.

### D6. Impostazioni con `Nemo.Configuration`
`ConfigurationGroup` in `/apps/harbour-202020` con chiavi `workMinutes`, `breakSeconds`, `alertRepeat` (`once`|`loop`), `alertType` (`notification`|`alarm`) e `alarmOnceSeconds`, più `testWorkSeconds`, solo per le prove e senza interfaccia, che accorcia il lavoro a pochi secondi. È ammesso in Harbour e si cancella con un comando solo: `dconf reset -f /apps/harbour-202020/`.

### D7. Lingue
Le stringhe passano da `qsTr()`. Si distribuiscono italiano e inglese (inglese come lingua di base dei sorgenti, come d'uso in Harbour).

### D8. Build, installazione e rimozione
Stesso flusso di `keyboard_jolla`: Docker avviato a mano, `sfdk config --push target SailfishOS-5.1.0.11-aarch64`, `sfdk build`, `sfdk check` per la validazione Harbour, copia dell'RPM e installazione via `ssh -F ../keyboard_jolla/ssh/jolla.conf jolla`. Per la rimozione: `rpm -e harbour-202020` e `dconf reset -f /apps/harbour-202020/`. Tutto documentato in `docs/sailfish.md`.

### D9. Licenza e nome
GPLv3 (come `reddo-keyboard`, accettata da OpenRepos e F-Droid). Nome pacchetto `harbour-202020`, nome visualizzato «20-20-20». Entrambi si possono cambiare fino alla prima pubblicazione.

## Risks / Trade-offs

- [Harbour non ammette il suono «Sveglia» col silenzioso] → risolto dallo spike: tutte le API usate superano `sfdk check`, quindi si mira al Jolla Store e a OpenRepos.
- [L'interfaccia D-Bus di `ngfd` non è documentata per le app, e la sua introspezione è sbagliata] → se un aggiornamento la cambiasse, la «Sveglia» non suonerebbe (resterebbe solo la notifica senza suono). Va ricontrollato nella checklist di accettazione a ogni versione di Sailfish.
- [`KeepAlive` consuma batteria durante i 20 minuti] → misurato nello spike: circa l'1% ogni 20 minuti, accettabile. È attivo solo durante le fasi e il loop.
- [Target di build 5.1 e telefono 5.2] → è la stessa combinazione già funzionante per `reddo-keyboard`.
- [Il loop resta acceso se l'utente si allontana] → è il comportamento voluto; «Stop» lo ferma subito.

## Migration Plan

Non c'è niente da migrare: è il primo rilascio. Per tornare indietro sul telefono bastano `rpm -e harbour-202020` e `dconf reset -f /apps/harbour-202020/`.
