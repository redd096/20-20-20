# Spike Sailfish: timer a schermo spento e suoni (12 ottobre 2026)

Attività 2.1–2.4 del change `sailfish-mvp`. Telefono: Jolla Phone 2026, Sailfish OS 5.2.0.18; build col target `SailfishOS-5.1.0.11-aarch64`. App usa e getta `harbour-202020-spike` in `build/spike/` (fuori da git), versioni 0.0.1–0.0.4.

## Regole Harbour (attività 2.3)

Elenchi letti nel target, in `/usr/share/sdk-harbour-rpmvalidator/`. L'RPM dello spike supera `sfdk check`.

| Modulo | Harbour |
| --- | --- |
| `Nemo.KeepAlive 1.2` | ammesso |
| `Nemo.Notifications 1.0` | ammesso (permesso incluso in `Base`) |
| `Nemo.Configuration 1.0` | ammesso |
| `QtMultimedia` fino a 5.6 | ammesso (serve il permesso Sailjail `Audio`) |
| `QtFeedback 5.0` | ammesso (parte ristretta) |
| `Nemo.Ngf` | **non ammesso** |

`sfdk check` richiede il target esplicito: `sfdk -c target=SailfishOS-5.1.0.11-aarch64 check <rpm>`.

## Timer a schermo spento (attività 2.1)

Il timer usa un istante di fine (`endTime`), un `Timer` mono-colpo e un controllo a ogni secondo, con `KeepAlive` attivo durante il conto alla rovescia.

| Prova | Esito |
| --- | --- |
| 1 min, app a icona, schermo spento | avviso puntuale, ritardo 0 s |
| 20 min, app a icona, schermo spento | avviso puntuale, ritardo 0 s |

Batteria (`/sys/class/power_supply/battery/charge_counter`): da 2 218 400 a 2 180 800 µAh fra le 16:34 e le 16:58, cioè 37,6 mAh (circa l'1% di 3760 mAh) in 23,6 minuti, compresi alcuni minuti a schermo acceso dopo l'avviso. Consumo accettabile, quindi non serve ripiegare su `BackgroundJob`.

## Suoni (attività 2.2)

Prove dell'utente col profilo normale, col silenzioso e con «non disturbare».

| Meccanismo | Volume che lo regola | Silenzioso / non disturbare | Schermo | Negli Eventi |
| --- | --- | --- | --- | --- |
| `Notification` con `sound` (file) | Suoneria | tace (vibra solo col profilo che lo consente) | non si accende | no |
| `Notification` con `category: "x-nemo.messaging.im"` | Suoneria (suono «Chat») | tace | si accende | no |
| `Notification` urgenza critica con `sound` | Suoneria | tace | si accende | sì, una sola (si sovrascrive) |
| `Audio` (QtMultimedia), processo normale | Applicazioni | tace (solo vibrazione) | — | — |
| `Audio` con `audioRole: Audio.AlarmRole` | Applicazioni: `audioRole` ignorato in Qt 5.6 | tace | — | — |
| `Audio` con `PULSE_PROP=media.role=alarm` nel launcher | nessuno, sempre al massimo | **suona** | non si accende | no |

- `Notification.setHintValue()` non esiste nella versione installata: gli hint come `x-nemo-feedback` non si possono impostare da QML.
- Aggiungere `module-stream-restore.id=x-clock-alert-volume` non cambia nulla: il suono resta al massimo.
- Il volume della sveglia di sistema è il valore `clock.alert.volume` di profiled, che SpeakerGain scrive e `ngfd` applica a ogni sveglia (nella policy audio il gruppo `alarm` ha solo `limit_volume`). Per leggerlo un'app deve parlare con `com.nokia.profiled` sul bus di sessione. Sailjail lo concede solo al profilo `voicecall-ui`, e infatti SpeakerGain usa `Sandboxing=Disabled`, chiave non ammessa in Harbour. Quindi un'app Harbour non può seguire quel volume: è un limite noto.
- La vibrazione con `HapticsEffect` (QtFeedback) funziona in tutti i casi.

## Scelte

- **Schermo spento**: `KeepAlive` attivo solo durante le fasi e il loop (D4 confermata).
- **«Notifica»**: `Notification` con urgenza critica e `sound` su un suono di sistema. Rispetta silenzioso e «non disturbare», accende lo schermo e lascia una sola voce negli Eventi, chiusa dall'app alla conferma.
- **«Sveglia»**: `Audio` di QtMultimedia, con il launcher che imposta `PULSE_PROP=media.role=alarm` per tutto il processo. Suona anche col silenzioso e col «non disturbare», a volume massimo.
- **Suoni**: si usano i file di sistema in `/usr/share/sounds/jolla-ringtones/stereo/` invece di includerne uno nel pacchetto.
- **Pubblicazione**: tutto è ammesso in Harbour, quindi si mira a Jolla Store e OpenRepos.

## Idee per dopo l'MVP

- Cursore «Volume sveglia» nelle impostazioni (proprietà `volume` di `Audio`), visto che lo stream sveglia è fisso al massimo.
- Solo per una build OpenRepos senza sandbox: leggere `clock.alert.volume` da profiled.
