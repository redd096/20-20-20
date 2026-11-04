# 20-20-20

A minimal app for the 20-20-20 rule: every 20 minutes in front of a screen, look at something about 20 feet (6 meters) away for 20 seconds. The app times the work and the break and alerts you when each one ends; you confirm before the next phase starts.

## Features

- Work and break timers with configurable durations: minutes and seconds (default 20 min / 20 s), minutes only, or seconds only.
- Overtime shown in red if you don't react to the end of a phase.
- Alert types: sound on media volume, system notification, or alarm. Play once or loop until stopped; optional vibration at every loop.
- Respects silent mode and do not disturb (or use alarm to ignore them); notification LED while the screen is off.
- Tapping the alert notification opens the app; Stop closes it.
- Option to not bring the app to the front when a phase ends.
- Cover buttons to start a phase or stop it.
- Optional Pomodoro mode: long break after N works, with a work counter.
- English and Italian.

The app works only while it is open (minimized is fine): nothing runs in the background after you close it.

## Install

**Sailfish OS**: download the RPM for your phone from the [0.2.0 release](https://github.com/redd096/20-20-20/releases/tag/sailfish-v0.2.0) (aarch64 for 64-bit devices, armv7hl for 32-bit ones such as the Xperia XA2) on the phone and open it from the file manager or the Downloads app (requires "Allow untrusted software" in Settings > Security).

Tested on device only on aarch64 (Jolla Phone 2026); the armv7hl package passes the Harbour validation but has not been tested on a real device.

## Uninstall

**Sailfish OS**: uninstalling leaves the settings and a few empty folders on the phone, and cleaners such as Mashka do not find them. To remove them, run this in a terminal on the phone after uninstalling:

```sh
dconf reset -f /apps/harbour-202020/
for d in .config .cache .local/share; do rmdir ~/$d/org.redd096/harbour-202020; rmdir ~/$d/org.redd096 2>/dev/null; done
```

`dconf reset -f` deletes the settings. `rmdir` deletes only empty folders, so `org.redd096` stays if another app of the same organization still uses it.

## Privacy

The app collects no data and sends nothing anywhere: it has no network access, because its Sailfish sandbox grants only the Audio permission. The settings are stored only on the phone, and the alerts are shown with the system notifications. There are no accounts, ads, analytics or trackers.

## Status

- **Sailfish OS** (`project_sailfish_os/`, package `harbour-202020`): version 0.2.0 (tag `sailfish-v0.2.0`). Behaviour in [`openspec/specs/`](openspec/specs/), history in the archived change [`sailfish-mvp`](openspec/changes/archive/2026-10-14-sailfish-mvp/proposal.md).
- **Android** (`project_android/`, for F-Droid): planned in a later change, on the same behavior spec.

## Layout

- `openspec/`: behavior specs shared by both apps and changes in progress (in Italian).
- `docs/`: build, install and test documentation ([index](docs/README.md)).
- `project_sailfish_os/`: Sailfish OS app sources.

## License

GPLv3, see [LICENSE](LICENSE).
