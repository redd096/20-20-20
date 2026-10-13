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
`CycleController` contiene lo stato (enum dei 5 stati di `break-cycle`), l'istante di fine fase `endTime` (ms epoch) e le funzioni `start()`, `confirm()` e `stop()`. Le pagine leggono solo le sue proprietà.
- Il tempo rimanente si calcola come `endTime - Date.now()`, mai contando i tick. Così resta corretto dopo un suspend o un ritardo.
- Un `Timer` da 1 s aggiorna la UI. Lo scadere viene controllato a ogni tick e da un secondo `Timer` mono-colpo impostato sul tempo rimanente.
- *Perché*: un solo punto di verità, facile da tradurre in Kotlin. *Alternativa scartata*: logica in C++, che con questa dimensione aggiungerebbe solo complessità.

### D4. Tenere sveglio il telefono con `Nemo.KeepAlive`
`KeepAlive { enabled: ... }` è attivo solo mentre una fase è in corso o un avviso è in loop. Impedisce il suspend della CPU ma non tiene acceso lo schermo. All'uscita dell'app il processo termina e il blocco viene rilasciato, quindi non resta nulla attivo.
- *Alternative scartate*:
  - `BackgroundJob`: si sveglia solo a intervalli fissi (30 s, 2,5 min, ...), troppo imprecisi per il limite di 5 s.
  - Allarmi di sistema `timed`: lasciano voci nel daemon di sistema anche ad app chiusa (contro `break-cycle`) e non sono ammessi in Harbour.
- *Confermato dallo spike*: l'import è ammesso da `sfdk check`, l'avviso arriva con 0 s di ritardo a schermo spento e 20 minuti costano circa l'1% di batteria (`docs/sailfish-spike.md`).

### D5. Suono: due percorsi, verificati con lo spike
Esiti completi in `docs/sailfish-spike.md`.
- «Notifica»: una `Notification` (`Nemo.Notifications`) con urgenza critica e `sound` su un suono di sistema. La riproduce il sistema (lipstick), sul volume Suoneria, rispettando silenzioso e «non disturbare». Accende lo schermo e lascia una sola voce negli Eventi, sostituita dall'avviso successivo. Come per tutte le app, la voce resta finché l'utente non la toglie. Toccarla non apre l'app: servirebbe un'azione D-Bus, rimandata insieme ai comandi da notifica.
- «Sveglia»: la stessa notifica critica, ma senza suono (accende lo schermo e mostra il messaggio), più un `Audio` di `QtMultimedia`. Il launcher C++ imposta `PULSE_PROP=media.role=alarm` (e `PULSE_PROP_OVERRIDE`) prima di avviare l'app, così gli stream audio del processo passano allo stream sveglia, che suona anche col silenzioso e col «non disturbare». La proprietà QML `audioRole` in Qt 5.6 viene ignorata. Le notifiche le suona un altro processo, quindi non risentono di questa impostazione.
- La vibrazione usa `HapticsEffect` (`QtFeedback 5.0`) in entrambi i modi.
- Il loop è un `Timer` che riproduce di nuovo il suono (o ripubblica la notifica) finché lo stato è «finito» e la ripetizione è «In loop».
- I suoni sono i file di sistema in `/usr/share/sounds/jolla-ringtones/stereo/` (`jolla-alarm.ogg`), senza file audio nel pacchetto.
- *Alternative scartate*: `Nemo.Ngf`, non ammesso in Harbour; hint `x-nemo-feedback`, che non si può impostare da QML (`setHintValue()` non esiste); `module-stream-restore.id=x-clock-alert-volume`, che non fa seguire al suono il volume della sveglia di sistema.
- *Limite noto*: la «Sveglia» suona sempre a volume massimo.

### D6. Impostazioni con `Nemo.Configuration`
`ConfigurationGroup` in `/apps/harbour-202020` con chiavi `workMinutes`, `breakSeconds`, `alertRepeat` (`once`|`loop`) e `alertType` (`notification`|`alarm`). È ammesso in Harbour e si cancella con un comando solo: `dconf reset -f /apps/harbour-202020/`.

### D7. Lingue
Le stringhe passano da `qsTr()`. Si distribuiscono italiano e inglese (inglese come lingua di base dei sorgenti, come d'uso in Harbour).

### D8. Build, installazione e rimozione
Stesso flusso di `keyboard_jolla`: Docker avviato a mano, `sfdk config --push target SailfishOS-5.1.0.11-aarch64`, `sfdk build`, `sfdk check` per la validazione Harbour, copia dell'RPM e installazione via `ssh -F ../keyboard_jolla/ssh/jolla.conf jolla`. Per la rimozione: `rpm -e harbour-202020` e `dconf reset -f /apps/harbour-202020/`. Tutto documentato in `docs/sailfish.md`.

### D9. Licenza e nome
GPLv3 (come `reddo-keyboard`, accettata da OpenRepos e F-Droid). Nome pacchetto `harbour-202020`, nome visualizzato «20-20-20». Entrambi si possono cambiare fino alla prima pubblicazione.

## Risks / Trade-offs

- [Harbour non ammette il suono «Sveglia» col silenzioso] → risolto dallo spike: tutte le API usate superano `sfdk check`, quindi si mira al Jolla Store e a OpenRepos.
- [La «Sveglia» è sempre a volume massimo] → accettato per l'MVP (la spec chiede solo che sia udibile). Il volume della sveglia di sistema (`clock.alert.volume` di profiled) non è leggibile da un'app con sandbox, quindi non è possibile in Harbour. Per questo l'app ha un proprio volume della sveglia (impostazione `alarmVolume`, 5–100%), applicato a `Audio.volume` con una curva quadratica, più vicina alla percezione del volume di una scala lineare.
- [`PULSE_PROP` è una variabile d'ambiente non documentata da Jolla] → se un aggiornamento di sistema la ignorasse, «Sveglia» seguirebbe il profilo come «Notifica». Va ricontrollato nella checklist di accettazione a ogni versione di Sailfish.
- [`KeepAlive` consuma batteria durante i 20 minuti] → misurato nello spike: circa l'1% ogni 20 minuti, accettabile. È attivo solo durante le fasi e il loop.
- [Target di build 5.1 e telefono 5.2] → è la stessa combinazione già funzionante per `reddo-keyboard`.
- [Il loop resta acceso se l'utente si allontana] → è il comportamento voluto; «Stop» e il pulsante principale lo fermano subito.

## Migration Plan

Non c'è niente da migrare: è il primo rilascio. Per tornare indietro sul telefono bastano `rpm -e harbour-202020` e `dconf reset -f /apps/harbour-202020/`.
