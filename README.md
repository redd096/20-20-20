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

**Sailfish OS** (aarch64): download the RPM from the [0.2.0 release](https://github.com/redd096/20-20-20/releases/tag/sailfish-v0.2.0) on the phone and open it from the file manager or the Downloads app (requires "Allow untrusted software" in Settings > Security).

## Status

- **Sailfish OS** (`project_sailfish_os/`, package `harbour-202020`): version 0.2.0 (tag `sailfish-v0.2.0`). Behaviour in [`openspec/specs/`](openspec/specs/), history in the archived change [`sailfish-mvp`](openspec/changes/archive/2026-10-14-sailfish-mvp/proposal.md).
- **Android** (`project_android/`, for F-Droid): planned in a later change, on the same behavior spec.

## Layout

- `openspec/`: behavior specs shared by both apps and changes in progress (in Italian).
- `docs/`: build, install and test documentation ([index](docs/README.md)).
- `project_sailfish_os/`: Sailfish OS app sources.

## License

GPLv3, see [LICENSE](LICENSE).
