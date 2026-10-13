# Sailfish spike: timers with the screen off and alert sounds (12 October 2026)

Tasks 2.1–2.4 of the `sailfish-mvp` change. Device: Jolla Phone 2026, Sailfish OS 5.2.0.18; built with the `SailfishOS-5.1.0.11-aarch64` target. Throwaway app `harbour-202020-spike` in `build/spike/` (not in git), versions 0.0.1–0.0.4.

## Harbour rules (task 2.3)

Lists read from the build target, in `/usr/share/sdk-harbour-rpmvalidator/`. The spike RPM passes `sfdk check`.

| Module | Harbour |
| --- | --- |
| `Nemo.KeepAlive 1.2` | allowed |
| `Nemo.Notifications 1.0` | allowed (permission included in `Base`) |
| `Nemo.Configuration 1.0` | allowed |
| `QtMultimedia` up to 5.6 | allowed (needs the Sailjail `Audio` permission) |
| `QtFeedback 5.0` | allowed (restricted subset) |
| `Nemo.Ngf` | **not allowed** |

`sfdk check` needs an explicit target: `sfdk -c target=SailfishOS-5.1.0.11-aarch64 check <rpm>`.

## Timer with the screen off (task 2.1)

The timer stores an end time (`endTime`), uses a single-shot `Timer` plus a check every second, and keeps `KeepAlive` enabled during the countdown.

| Test | Result |
| --- | --- |
| 1 min, app minimized, screen off | alert on time, 0 s delay |
| 20 min, app minimized, screen off | alert on time, 0 s delay |

Battery (`/sys/class/power_supply/battery/charge_counter`): from 2 218 400 to 2 180 800 µAh between 16:34 and 16:58, that is 37.6 mAh (about 1% of 3760 mAh) in 23.6 minutes, including a few minutes with the screen on after the alert. Acceptable, so there is no need to fall back to `BackgroundJob`.

## Sounds (task 2.2)

Tested by the user with the normal profile, the silent profile and do not disturb.

| Mechanism | Controlled by | Silent / do not disturb | Screen | In Events |
| --- | --- | --- | --- | --- |
| `Notification` with `sound` (file) | ringtone volume | muted | stays off | no |
| `Notification` with `category: "x-nemo.messaging.im"` | ringtone volume ("Chat" sound) | muted | turns on | no |
| `Notification`, critical urgency, with `sound` | ringtone volume | muted | turns on | yes, a single entry (replaced) |
| `Audio` (QtMultimedia), plain process | application volume | muted (vibration only) | — | — |
| `Audio` with `audioRole: Audio.AlarmRole` | application volume: `audioRole` is ignored by Qt 5.6 | muted | — | — |
| `Audio` with `PULSE_PROP=media.role=alarm` in the launcher | none, always full volume | **rings** | stays off | no |

- `Notification.setHintValue()` does not exist in the installed version: hints such as `x-nemo-feedback` cannot be set from QML.
- Adding `module-stream-restore.id=x-clock-alert-volume` changes nothing: the sound stays at full volume.
- The system alarm volume is profiled's `clock.alert.volume` value, written by SpeakerGain and applied by `ngfd` to each alarm (in the audio policy the `alarm` group only has `limit_volume`). Reading it means talking to `com.nokia.profiled` on the session bus. Sailjail grants that only to the `voicecall-ui` profile, and SpeakerGain in fact uses `Sandboxing=Disabled`, a key Harbour does not allow. So a Harbour app cannot follow that volume: known limitation.
- Vibration through `HapticsEffect` (QtFeedback) works in every case.

## Decisions

- **Screen off**: `KeepAlive` enabled only during countdowns and alert loops (design decision D4 confirmed).
- **"Notification" alert**: critical `Notification` with `sound` set to a system sound. It respects silent mode and do not disturb, turns the screen on and leaves a single entry in Events.
- **"Alarm" alert**: QtMultimedia `Audio`, with the launcher setting `PULSE_PROP=media.role=alarm` for the whole process. It rings even in silent mode and do not disturb, at full volume.
- **Sounds**: the system files in `/usr/share/sounds/jolla-ringtones/stereo/` are used instead of bundling one in the package.
- **Publishing**: everything is allowed in Harbour, so the targets are the Jolla Store and OpenRepos.

## Ideas for after the MVP

- An "Alarm volume" slider in the settings (`Audio.volume`), since the alarm stream is fixed at full volume.
- Only for an OpenRepos build without sandbox: read `clock.alert.volume` from profiled.

## Follow-up: system alarm through ngfd (task 6.4, 13 October 2026)

Goal: use the real system alarm (the user's alarm tone, at the alarm volume set in SpeakerGain) instead of imitating it with `PULSE_PROP`, while staying inside Harbour. Spike app version 0.0.5.

How `ngfd` must be called:

- Service `com.nokia.NonGraphicFeedback1.Backend`, path `/com/nokia/NonGraphicFeedback1`, but interface **`com.nokia.NonGraphicFeedback1`** and signature **`Play(s event, a{sv} properties) -> u id`**, `Stop(u id)`. The introspection data (interface `...Backend`, `sa(sv)`) is wrong: both combinations are rejected, and `gdbus` cannot be used because it forces the introspected signature.
- `ngfd` tracks the D-Bus client of each event: when the client disconnects, its events are cancelled, and only the same client can stop them (`Access denied` otherwise). So a one-shot `busctl call` from a terminal plays nothing; the call has to come from a long-lived connection, such as the app's own.
- The `clock` event (`/usr/share/ngfd/events.d/clock.ini`) uses `clock.alert.tone`, the `x-clock-alert-volume` stream and the `alarm` vibration, repeats by itself until stopped and fades in over 20 s.

Results from the app, with `Nemo.DBus 2.0` (`DBusInterface` on the system bus):

| Test | Result |
| --- | --- |
| `clock` with `call()` and with `typedCall()` | user's alarm tone, vibration, loops until `Stop` |
| `clock` with the silent profile | **rings** |
| alarm volume changed in SpeakerGain | followed |
| `clock` after 10 s, app minimized, screen off | rings; the screen stays off |
| `sms` | a single vibration, no sound: not useful |
| `sfdk check` with `Nemo.DBus 2.0` | passes |

Decisions:

- **"Alarm" alert**: the `ngfd` `clock` event, started and stopped by the app. It replaces `QtMultimedia` with `PULSE_PROP` and the app's own alarm volume setting, which are no longer needed.
- The critical notification without sound stays, to turn the screen on.
- **"Notification" alert**: unchanged (critical notification with a system sound).
