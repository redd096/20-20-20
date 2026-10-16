# Design

## Context

`AlertPlayer.qml` ha due percorsi. Con «Notifica» pubblica una notifica critica con `sound` impostato: il suono lo riproduce lipstick sul volume Suoneria, e il loop ripubblica la notifica ogni 4 s con un `Timer` (banner e suono a ogni giro). Con «Sveglia» pubblica la stessa notifica senza suono e il suono arriva dall'evento `clock` di `ngfd`. La vibrazione della «Notifica» è un `HapticsEffect` all'inizio dell'avviso. `KeepAlive` è attivo mentre l'avviso è in loop o mentre aspetta di fermare una sveglia «Una volta».

Lo spike del 12 ottobre (`docs/sailfish-spike.md`) ha verificato che `Audio` di QtMultimedia, in un processo normale, usa il volume Applicazioni ed è muto col profilo silenzioso. QtMultimedia richiede il permesso Sailjail `Audio`, tolto nella release 14 quando la «Sveglia» è passata a `ngfd`. Minidoro, pubblicata su Harbour, dichiara lo stesso permesso e riproduce i suoni con QtMultimedia.

## Goals / Non-Goals

**Goals:**
- Lasciare invariati il percorso «Volume suoneria» e il percorso «Sveglia».
- Un solo meccanismo di loop per le due «Notifiche».

**Non-Goals:**
- Leggere lo stato di «non disturbare»: col volume Applicazioni l'avviso suona comunque (vedi proposal).

## Decisions

### D1. Chiave dconf `notificationVolume`
Stringa `app` (predefinita) o `ringtone`, come `alertType` e `alertRepeat`: se le voci del menu vengono riordinate, le impostazioni salvate restano valide. `harbour-202020.qml` la passa ad `AlertPlayer` come proprietà `volume`; qualsiasi valore diverso da `ringtone` vale `app`.

### D2. `Audio` con il file di sistema di oggi
Un elemento `Audio` con `source` uguale a `notificationSoundFile` (`jolla-messagetone.ogg`), caricato all'avvio dell'app (`autoLoad` predefinito) per non avere ritardi al primo avviso. Con `volume: app` la notifica viene pubblicata con `sound` vuoto, come per la «Sveglia», e il suono parte con `Audio.play()`.
- Alternativa scartata: `SoundEffect`, come Minidoro. Legge solo WAV, quindi servirebbe un file nel pacchetto con la sua licenza; `Audio` è già stato provato nello spike.

### D3. Loop col `Timer` esistente
Lo stesso `notificationLoop` (ogni 4 s) chiama `Audio.play()` invece di ripubblicare la notifica quando `volume` è `app`. Il ritmo è uguale a quello del volume Suoneria e `stop()` ferma timer e `Audio` in un solo punto.
- Alternativa scartata: `Audio.loops = Audio.Infinite` (la proprietà che ripete il file appena finisce, usata da Minidoro su `SoundEffect`). Il suono (3,2 s) ripartirebbe senza pausa, mentre col timer ogni 4 s c'è il suono e poi circa 0,8 s di silenzio, come col volume Suoneria; e ci sarebbe un secondo meccanismo di loop da fermare.
- `KeepAlive` resta com'è: col loop è già attivo (`looping`), con «Una volta» non c'è nessun timer nostro da tenere sveglio.

### D4. Permesso Sailjail `Audio`
`Permissions=Audio` nella sezione `[X-Sailjail]` del `.desktop`. Non serve nessun `Requires` in più nel `.spec`: il modulo QML di QtMultimedia fa parte del sistema ed è ammesso in Harbour.

## Risks / Trade-offs

- [Col permesso `Audio` le notifiche potrebbero sparire di nuovo dagli Eventi (task 6.8 di `sailfish-mvp`, causa mai chiarita)] → La checklist ripete B11 sulla nuova release. Se fallisce, si prova prima il riavvio della home, poi si riapre la decisione.
- [`Audio` potrebbe essere muto anche con «non disturbare», contro quanto atteso] → Il comportamento sarebbe solo più restrittivo: si corregge lo scenario della spec dopo la prova sul telefono.
- [Con «Una volta» e lo schermo spento il suono lo riproduce ora il processo dell'app, non lipstick o `ngfd`: se il telefono si sospendesse durante i 3 s il suono verrebbe tagliato (di solito PulseAudio lo tiene sveglio mentre uno stream suona)] → Riga apposita nella checklist; se succede, `KeepAlive` attivo anche mentre `Audio` suona.
- [Volume Applicazioni a zero: l'avviso non si sente] → Resta la vibrazione, come col profilo silenzioso; nessuna azione.
