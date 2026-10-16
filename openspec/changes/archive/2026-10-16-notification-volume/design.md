# Design

## Context

`AlertPlayer.qml` ha due percorsi. Con «Notifica» pubblica una notifica critica con `sound` impostato: il suono lo riproduce lipstick sul volume Suoneria, e il loop ripubblica la notifica ogni 4 s con un `Timer` (banner e suono a ogni giro). Con «Sveglia» pubblica la stessa notifica senza suono e il suono arriva dall'evento `clock` di `ngfd`. La vibrazione della «Notifica» è un `HapticsEffect` all'inizio dell'avviso. `KeepAlive` è attivo mentre l'avviso è in loop o mentre aspetta di fermare una sveglia «Una volta».

Lo spike del 12 ottobre (`docs/sailfish-spike.md`) ha verificato che `Audio` di QtMultimedia, in un processo normale, usa il volume delle applicazioni ed è muto col profilo silenzioso. La release 24 ha mostrato che non è muto con «non disturbare». QtMultimedia richiede il permesso Sailjail `Audio`, tolto nella release 14 quando la «Sveglia» è passata a `ngfd`. Minidoro, pubblicata su Harbour, dichiara lo stesso permesso e riproduce i suoni con QtMultimedia. Lo stato di «non disturbare» è nella chiave dconf `/lipstick/do_not_disturb` (booleana), letta dalla home di Sailfish.

## Goals / Non-Goals

**Goals:**
- Lasciare invariati i percorsi «Notifica» e «Sveglia».
- Un solo meccanismo di loop per «Suono» e «Notifica».

**Non-Goals:**
- Un banner unico per «Notifica» (vedi proposal, Fuori scope).

## Decisions

### D1. Tre valori per `alertType`
`alertType` vale `sound` (predefinito), `notification` o `alarm`, e nel menu le voci sono in quest'ordine. `notification` conserva il significato di prima, quindi un valore già salvato resta valido. `harbour-202020.qml` passa `alarm` e `notification` così come sono e ogni altro valore come `sound`. La chiave `notificationVolume` della release 24 sparisce senza migrazione: c'era solo sul telefono dell'autore.
- Alternativa scartata: una chiave e un menu «Volume» separati, visibili solo con «Notifica» (release 24). Due menu per una sola scelta, e più combinazioni da spiegare.

### D2. `Audio` con il file di sistema di oggi
Un elemento `Audio` con `source` uguale a `notificationSoundFile` (`jolla-messagetone.ogg`), caricato all'avvio dell'app (`autoLoad` predefinito) per non avere ritardi al primo avviso. Con `sound` la notifica viene pubblicata con `sound` vuoto, come per la «Sveglia», e il suono parte con `Audio.play()`.
- Alternativa scartata: `SoundEffect`, come Minidoro. Legge solo WAV, quindi servirebbe un file nel pacchetto con la sua licenza; `Audio` è già stato provato nello spike.

### D3. Loop col `Timer` esistente
Lo stesso `notificationLoop` (ogni 4 s) col tipo `sound` riproduce solo il suono invece di ripubblicare la notifica. Il ritmo è uguale a quello di «Notifica» e `stop()` ferma timer e `Audio` in un solo punto.
- Alternativa scartata: `Audio.loops = Audio.Infinite` (la proprietà che ripete il file appena finisce, usata da Minidoro su `SoundEffect`). Il suono (3,2 s) ripartirebbe senza pausa, mentre col timer ogni 4 s c'è il suono e poi circa 0,8 s di silenzio, come con «Notifica»; e ci sarebbe un secondo meccanismo di loop da fermare.
- `KeepAlive` resta com'è: col loop è già attivo (`looping`), con «Una volta» non c'è nessun timer nostro da tenere sveglio.

### D4. Permesso Sailjail `Audio`
`Permissions=Audio` nella sezione `[X-Sailjail]` del `.desktop`. Non serve nessun `Requires` in più nel `.spec`: il modulo QML di QtMultimedia fa parte del sistema ed è ammesso in Harbour.

### D5. «Non disturbare» letto da dconf
Un `ConfigurationValue` sulla chiave `/lipstick/do_not_disturb`, con valore predefinito `false`. Prima di ogni riproduzione del tipo `sound`, all'inizio e a ogni giro del loop, l'app salta il suono se la chiave vale `true`; la notifica e la vibrazione restano, come con «Notifica». Controllare a ogni giro fa sì che attivare «non disturbare» durante un loop zittisca i giri successivi.
- Se la sandbox non lascia leggere la chiave, il valore resta `false` e l'avviso suona come nella release 24: nessun guasto, solo il requisito non rispettato.

## Risks / Trade-offs

- [Sailjail potrebbe non lasciar leggere `/lipstick/do_not_disturb`] → La checklist verifica il caso con «non disturbare» attivo; se il suono si sente ancora, si torna alla decisione della release 24 (suona anche con «non disturbare») e si corregge la spec.
- [Col permesso `Audio` le notifiche potrebbero sparire di nuovo dagli Eventi (task 6.8 di `sailfish-mvp`, causa mai chiarita)] → Verificato sulla release 24 (B11 OK); la checklist lo ripete sulla release finale.
- [Con «Una volta» e lo schermo spento il suono lo riproduce il processo dell'app, non lipstick o `ngfd`: se il telefono si sospendesse durante i 3 s il suono verrebbe tagliato] → Verificato sulla release 24 (suono intero).
- [Volume delle applicazioni a zero: l'avviso non si sente] → Resta la vibrazione, come col profilo silenzioso; nessuna azione.
