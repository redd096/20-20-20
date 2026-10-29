# 20-20-20 for Sailfish OS: build, install and removal

Sources are in `project_sailfish_os/`, package `harbour-202020`. Build output goes to `build/sailfish/`, which is ignored by git.

## Requirements

- Sailfish SDK in `~/SailfishOS/` with the `SailfishOS-5.1.0.11-aarch64` and `SailfishOS-5.1.0.11-armv7hl` targets.
- Docker, started only for the build.
- SSH access to the phone. The commands below use an ssh config file with a host called `jolla`; replace `-F ../keyboard_jolla/ssh/jolla.conf jolla` with your own host. Keep that config out of this repository.

## Build

From the project root:

```sh
sudo systemctl start docker
mkdir -p build/sailfish && cd build/sailfish
sg docker -c "~/SailfishOS/bin/sfdk -c target=SailfishOS-5.1.0.11-aarch64 -c no-fix-version build ../../project_sailfish_os"
sg docker -c "~/SailfishOS/bin/sfdk -c target=SailfishOS-5.1.0.11-aarch64 check RPMS/harbour-202020-[0-9]*.aarch64.rpm"
cd ../..
sudo systemctl stop docker
```

- `systemctl start/stop docker` runs Docker only for the build and stops it afterwards.
- `sg docker -c "…"` runs the command with the `docker` group, which `sfdk` needs.
- `-c target=…` selects the build target; `-c no-fix-version` uses the version written in the `.spec` file instead of deriving it from git tags.
- `sfdk build` compiles into `build/sailfish/` and writes the RPM to `build/sailfish/RPMS/`.
- `sfdk check` runs the Jolla Store (Harbour) validation. It must end with `Validation succeeded`.

The 32-bit package (armv7hl, for phones such as the Xperia XA2) is built the same way in its own folder, so the two targets do not mix build files:

```sh
mkdir -p build/sailfish-armv7hl && cd build/sailfish-armv7hl
sg docker -c "~/SailfishOS/bin/sfdk -c target=SailfishOS-5.1.0.11-armv7hl -c no-fix-version build ../../project_sailfish_os"
sg docker -c "~/SailfishOS/bin/sfdk -c target=SailfishOS-5.1.0.11-armv7hl check RPMS/harbour-202020-[0-9]*.armv7hl.rpm"
cd ../..
sg docker -c "~/SailfishOS/bin/sfdk engine stop"
```

- `sfdk engine stop` stops the SDK build engine started by `sfdk build`; run it before stopping Docker.

## Publishing

Checked on 2026-10-25 with `sfdk check` on `harbour-202020-0.2.0-1.aarch64.rpm`: `Validation succeeded` (Sandboxing included, with the Audio permission and the D-Bus name), so the package can go to both stores. Checked again on 2026-10-29 on `harbour-202020-0.2.0-1.armv7hl.rpm`: `Validation succeeded`, same single warning. The armv7hl package is not tested on a device (the test phone is aarch64).

- **Jolla Store (Harbour)**: allowed by the automatic validation, which has 1 rpmlint warning, not blocking: unstripped binary. The manual review by Jolla may still object to the D-Bus name used by the notification tap (Store limits on D-Bus were discussed in the Sailfish OS meeting of 2026-01-15).
- **OpenRepos**: allowed, it does not require the Harbour rules.

## Install

```sh
scp -F ../keyboard_jolla/ssh/jolla.conf build/sailfish/RPMS/harbour-202020-[0-9]*.aarch64.rpm jolla:/home/defaultuser/
ssh -t -F ../keyboard_jolla/ssh/jolla.conf jolla "devel-su rpm -Uvh /home/defaultuser/harbour-202020-[0-9]*.aarch64.rpm"
```

- `scp` copies the RPM to the phone's home directory.
- `ssh -t` opens an interactive terminal, because `devel-su` asks for the phone's root password.
- `rpm -Uvh` installs the package, or upgrades the installed one.

The "20-20-20" app appears in the launcher.

## Stored settings

The app stores its settings in dconf under `/apps/harbour-202020/`. A missing key means its default value.

| Key | Values | Default |
| --- | --- | --- |
| `durationUnits` | units shown in the settings: `minutesAndSeconds` (work in minutes, break in seconds), `minutesAndMinutes` or `secondsAndSeconds` | `minutesAndSeconds` |
| `workSeconds` | work duration in seconds: 60 to 3600 (1 to 60 min) when shown in minutes, 5 to 120 when shown in seconds | 1200 |
| `breakSeconds` | break duration in seconds, same ranges as `workSeconds` | 20 |
| `alertRepeat` | `once`, or `loop` (until Stop) | `loop` |
| `alertType` | `sound` (played by the app on the media volume, muted in silent mode and do not disturb), `notification` (a system notification on the ringtone volume, muted in silent mode and do not disturb; the loop shows the banner again at every repeat), or `alarm` (the system alarm: your alarm tone and volume, rings even in silent mode) | `sound` |
| `loopVibration` | with the `loop` repeat and the `sound` or `notification` type, vibrate at every repeat (`true`) or only at the start (`false`); the vibration ignores silent mode and do not disturb | `false` |
| `alarmOnceSeconds` | how long the `alarm` type rings with the `once` repeat, seconds from 5 to 60 | 30 |
| `bringToFront` | at the end of each phase, bring the app to the foreground (`true`) or only show the alert (`false`); the settings page is closed in both cases | `true` |
| `pomodoro` | Pomodoro mode: a long break after a number of works, and a work counter on the main page | `false` |
| `longBreakAfter` | number of works before the long break, 1 to 10 | 3 |
| `longBreakSeconds` | long break duration in seconds, same ranges as `breakSeconds`; reset with the other durations when the units change (900 for `minutesAndMinutes`, 60 otherwise) | 60 |

To read them, or reset them to the defaults, without root:

```sh
ssh -F ../keyboard_jolla/ssh/jolla.conf jolla "dconf dump /apps/harbour-202020/"
ssh -F ../keyboard_jolla/ssh/jolla.conf jolla "dconf reset -f /apps/harbour-202020/"
```

- `dconf dump` prints every key stored by the app.
- `dconf reset -f` deletes them all: on its next start the app uses the defaults.

For quick tests on the device, choose the units "Seconds and seconds" in the settings: work and break then last from 5 to 120 seconds. Changing the units resets both durations to the defaults of the new units.

Release 23 changed the keys that store the durations, without migrating the old values: after upgrading from an older release, run the `dconf reset -f` command above once.

## D-Bus service

While it runs, the app owns `org.redd096.harbour-202020` on the session bus (Sailjail allows only `OrganizationName.ApplicationName` from the `.desktop` file). It exports one method, `org.redd096.harbour202020.showMainPage` at `/org/redd096/harbour202020`, which the alert notification calls when it is tapped: the app comes to the foreground on the main page. There is no `.service` file, so nothing can start the app through D-Bus.

The alert notification uses the system category `im.received`, whose only effect is the notification LED while the screen is off.

## Removal

```sh
ssh -t -F ../keyboard_jolla/ssh/jolla.conf jolla "devel-su rpm -e harbour-202020; rm -f /home/defaultuser/harbour-202020-[0-9]*.rpm; dconf reset -f /apps/harbour-202020/"
```

- `rpm -e` uninstalls the package: program, QML files, icons and launcher entry.
- `rm -f` deletes the RPM copied earlier.
- `dconf reset -f` deletes the settings stored by the app.

After these commands nothing of the app is left on the phone. The app installs no services and nothing that starts automatically. A notification may remain in the Events view until you dismiss it, as with any app.
