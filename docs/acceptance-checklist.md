# Acceptance checklist (Sailfish OS)

On-device tests for the `sailfish-mvp` change: every scenario of the `break-cycle` and `break-alerts` specs, plus the app in English. Rows A19-A23 were added by the `duration-units` change, rows B12-B20 by the `notification-volume` change, rows B21-B25 by the `vibration-loop` change.

**Before starting**

- Install the final RPM (see [`sailfish.md`](sailfish.md)).
- Reset the settings to the defaults:
  `ssh -F ../keyboard_jolla/ssh/jolla.conf jolla "dconf reset -f /apps/harbour-202020/"`
- Unless a test says otherwise, use the defaults: work 20 min, break 20 s, repeat "Loop until stopped", type "Sound".
- Short tests may set work to 1 min in the settings; test A2 and B1 MUST use the default 20 min.

Result: `OK`, `FAIL` (with a note) or `-` (not run).

Device: Jolla, Sailfish OS 5.1.0.11, release 21. Date: 2026-10-14.

## A. Break cycle (`break-cycle`)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| A1 | App start | Open the app | State "Waiting for work", main button "Start" | OK |
| A2 | Back after screen off | Start the 20 min work, turn the screen off, turn it on after 5 min | About 15:00 left | OK |
| A3 | Work start | Press "Start" | "Work" running, countdown = work duration, only "Stop" | OK |
| A4 | Work end | Let work reach 0 | Still "Work", now finished; alert starts; only "Stop" | OK |
| A5 | No confirmation | Leave finished work alone for 1 min | Stays "Work" finished, overtime grows, break does not start | OK |
| A6 | Stop after work end | "Loop until stopped", work finished, press "Stop" | Alert stops, state "Waiting for break", break does not start | OK |
| A7 | Break start | In "Waiting for break" press "Start break" | "Break" running, countdown = break duration | OK |
| A8 | Break end | Let break reach 0 | Still "Break", now finished; alert starts; only "Stop" | OK |
| A9 | Work postponed | In "Waiting for break" press "Restart work" | "Work" running with a new full countdown | OK |
| A10 | Work ended early | Work running with time left, press "Stop" | Countdown cancelled, no alert later, state "Waiting for break" | OK |
| A11 | Stop during break | Break running, press "Stop" | Countdown cancelled, no alert later, state "Waiting for work" | OK |
| A12 | Quick answer | Work ends, press "Stop" within 5 s | Overtime never shown | OK |
| A13 | Overtime after screen off | Work ends with the screen off, turn it on 2 min later | 0:00 and a red overtime of about -2:00 | OK |
| A14 | Defaults | `dconf reset -f /apps/harbour-202020/`, open settings | Units "Minutes and seconds", work 20 min, break 20 s, repeat "Loop until stopped", type "Sound" | OK |
| A15 | Settings kept | Set work 25 min, close and reopen the app | Work 25 min | OK |
| A16 | Change during a phase | Work running, change work duration | Current phase ends at its old time; the next work uses the new duration | OK |
| A17 | Close during work | Work running, close the app; after the work time check `ps` via ssh | No alert, no `harbour-202020` process | OK |
| A18 | No autostart | Reboot the phone | The app does not start by itself | OK |
| A19 | Ranges in minutes | Units "Minutes and minutes", move both sliders to the ends | Work and break from 1 to 60 min, steps of 1 min | OK |
| A20 | Ranges in seconds | Units "Seconds and seconds", move both sliders to the ends | Work and break from 5 to 120 s, steps of 5 s | OK |
| A21 | Units change | Units "Minutes and seconds", work 30 min, choose "Minutes and minutes" | Sliders show at once work 25 min and break 5 min | OK |
| A22 | Same units again | Units "Minutes and seconds", work 30 min, choose "Minutes and seconds" again | Work still 30 min | OK |
| A23 | Units change during a phase | Work running, choose "Seconds and seconds" | Current phase ends at its old time; the next work lasts 20 s | OK |
| A24 | Start work from the cover | "Waiting for work", minimize, tap the play action on the cover | Work starts, the cover shows the remaining time | OK |
| A25 | Start break from the cover | "Waiting for break", minimize, tap the play action on the cover | The break starts, the cover shows the remaining time | OK |
| A26 | Stop from the cover during the alert | "Loop until stopped", "Bring app to front" off, minimize, work ends, tap the cancel action on the cover | The alert stops, the state becomes "Waiting for break", the app stays minimized | OK |
| A27 | Stop from the cover during the break | Break running, minimize, tap the cancel action on the cover | The break ends, the state becomes "Waiting for work" | OK |

## B. Break alerts (`break-alerts`)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| B1 | Screen off during work | Start the 20 min work, minimize, screen off | Alert within 5 s of the end | OK |
| B2 | Break end | Break ends while looking away | Alert recognizable without looking (sound and/or vibration) | OK |
| B3 | Once | Repeat "Once", work ends | Sound plays once, state stays "Work" finished | OK |
| B4 | Loop until Stop | Repeat "Loop until stopped", work ends, press "Stop" after 30 s | Sound repeats for 30 s, stops on the press | OK |
| B5 | Notification, silent profile | Type "Notification", silent profile, work ends | No sound, "Work" still becomes finished | OK |
| B6 | Alarm, silent profile | Type "Alarm", silent profile, work ends | Alert is audible | OK |
| B7 | System alarm volume | Type "Alarm", lower the alarm volume in system settings, work ends | Alarm ringtone at the lower volume | OK |
| B8 | Alarm once | Type "Alarm", "Once", alarm length 30 s, work ends | Rings about 30 s, then silent; state stays "Work" finished | OK |
| B9 | Alarm length kept | Set alarm length 15 s, close and reopen the app | Alarm length 15 s | OK |
| B10 | Stop during loop | "Loop until stopped", break finished, press "Stop" | Sound stops at once, state "Waiting for work" | OK |
| B11 | Events list | After an alert, open the Events view | The app's notification is listed (see task 6.8) | OK |
| B12 | Type default | `dconf reset -f /apps/harbour-202020/`, open settings | Type "Sound"; "Alarm length" is shown only with type "Alarm" and repeat "Once" | OK |
| B13 | Media volume | Type "Sound", with the app open lower the volume with the keys, work ends | Alert at the lower volume; the ringtone volume in system settings is unchanged | OK |
| B14 | Sound, silent profile | Type "Sound", silent profile, work ends | No sound, "Work" still becomes finished | OK |
| B15 | Sound, do not disturb | Type "Sound", do not disturb on, work ends | No sound, "Work" still becomes finished | OK |
| B16 | Notification, do not disturb | Type "Notification", do not disturb on, work ends | No sound, "Work" still becomes finished | OK |
| B17 | One banner in loop | Type "Sound", "Loop until stopped", work ends, press "Stop" after 30 s | Sound repeats for 30 s, the banner appears only once | OK |
| B18 | Type kept | Choose type "Notification", close and reopen the app | Type "Notification" | OK |
| B19 | Once with screen off | Type "Sound", repeat "Once", minimize, screen off, work ends | The whole sound is heard (about 3 s) | OK |
| B20 | Banner repeated with Notification | Type "Notification", "Loop until stopped", work ends | The banner appears again at every repeat | OK |
| B21 | Vibration only at the start | "Vibrate at every repeat" off, "Loop until stopped", work ends | Vibrates only at the start, the sound repeats | OK |
| B22 | Vibration at every repeat | "Vibrate at every repeat" on, "Loop until stopped", work ends, press "Stop" after 30 s | Vibrates at every repeat of the sound for 30 s, stops on the press | OK |
| B23 | Vibration only, silent profile | "Vibrate at every repeat" on, type "Sound", "Loop until stopped", silent profile, work ends | No sound, vibrates at every repeat until "Stop" | OK |
| B24 | Switch kept | Turn "Vibrate at every repeat" on, close and reopen the app | The switch is on | OK |
| B25 | Switch visibility | Choose repeat "Once", then type "Alarm" | The switch is shown only with "Loop until stopped" and type "Sound" or "Notification" | OK |
| B26 | Brought to front | "Bring app to front" on, open another app, work ends | The app comes to the foreground on the main page, with "Stop" | OK |
| B27 | Alert only | "Bring app to front" off, settings open, open another app, work ends, then open the app from Home | The alert starts and you stay in the other app; the app opens on the main page, with "Stop" | OK |
| B28 | Settings closed while dragging | Short durations, settings open, hold a duration slider while the phase ends | The settings close without errors; reopened, the duration is the one saved before dragging | OK |
| B29 | Front switch kept | Turn "Bring app to front" off, close and reopen the app | The switch is off | OK |
| B30 | Tap on the banner | "Bring app to front" off, open another app, work ends, tap the banner | The app comes to the foreground on the main page, with "Stop" | - |
| B31 | Tap in Events | Minimize, work ends, open Events, tap the notification | The app comes to the foreground on the main page | - |
| B32 | LED with screen off | Screen off, work ends, let the screen turn off again without opening Events | The notification LED blinks | - |
| B33 | LED off after Events | LED blinking, open Events | The LED stops | - |
| B34 | LED after Stop (observation) | LED blinking, open the app from Home and press "Stop" without opening Events, turn the screen off | Note whether the LED still blinks | - |

## C. Language

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| C1 | Italian | System language Italian, walk through every state and the settings | No English or untranslated strings | OK |
| C2 | English | System language English (needs a reboot), same walk-through | No Italian or untranslated strings | OK |

## Notes

- All 31 scenarios passed on release 21 (2026-10-14).
- Release 23 (`duration-units`, 2026-10-16): A14, A15, A16 and the new A19-A23 passed, in Italian, after `dconf reset -f`.
- Release 24 (`notification-volume`, first version with a separate Volume menu, 2026-10-16): all rows passed; with do not disturb the media-volume sound was audible, as then intended. Release 25 merged the Volume menu into the "Sound" type and mutes it in do not disturb, so the rows were reset.
- Release 25 (2026-10-16): A14, B3, B4, B5, B10, B11 and B12-B20 passed, in Italian, after `dconf reset -f`. B15: with do not disturb the "Sound" type is silent, so the sandbox can read `/lipstick/do_not_disturb`.
- Release 26 (`vibration-loop`, 2026-10-16): B21-B25 passed, in Italian.
- Release 27 (`foreground-toggle`, 2026-10-23): B26-B29 passed, in Italian. B28: the dragged value is not saved, the previous duration stays.
- Release 28 (`cover-actions`, 2026-10-23): A24-A27 passed, in Italian.
- A17: `ps aux | grep harbour-202020` listed only the ssh shell and the `grep` itself, so no app process was left.
- C1: the Italian label of "Restart work" was "Riprendi lavoro" ("resume"), misleading because the work timer restarts from the full duration. Changed to "Riavvia lavoro" in release 22.
