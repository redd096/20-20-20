# Acceptance checklist (Sailfish OS)

On-device tests for the `sailfish-mvp` change: every scenario of the `break-cycle` and `break-alerts` specs, plus the app in English.

**Before starting**

- Install the final RPM (see [`sailfish.md`](sailfish.md)).
- Remove the test-only key, so the work phase uses the real duration:
  `ssh -F ../keyboard_jolla/ssh/jolla.conf jolla "dconf reset /apps/harbour-202020/testWorkSeconds"`
- Unless a test says otherwise, use the defaults: work 20 min, break 20 s, repeat "Loop until stopped", type "Notification".
- Short tests may set work to 1 min in the settings; test A2 and B1 MUST use the default 20 min.

Result: `OK`, `FAIL` (with a note) or `-` (not run).

Device: Jolla, Sailfish OS 5.1.0.11, release ___. Date: ___.

## A. Break cycle (`break-cycle`)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| A1 | App start | Open the app | State "Waiting for work", main button "Start" | |
| A2 | Back after screen off | Start the 20 min work, turn the screen off, turn it on after 5 min | About 15:00 left | |
| A3 | Work start | Press "Start" | "Work" running, countdown = work duration, only "Stop" | |
| A4 | Work end | Let work reach 0 | Still "Work", now finished; alert starts; only "Stop" | |
| A5 | No confirmation | Leave finished work alone for 1 min | Stays "Work" finished, overtime grows, break does not start | |
| A6 | Stop after work end | "Loop until stopped", work finished, press "Stop" | Alert stops, state "Waiting for break", break does not start | |
| A7 | Break start | In "Waiting for break" press "Start break" | "Break" running, countdown = break duration | |
| A8 | Break end | Let break reach 0 | Still "Break", now finished; alert starts; only "Stop" | |
| A9 | Work postponed | In "Waiting for break" press "Restart work" | "Work" running with a new full countdown | |
| A10 | Work ended early | Work running with time left, press "Stop" | Countdown cancelled, no alert later, state "Waiting for break" | |
| A11 | Stop during break | Break running, press "Stop" | Countdown cancelled, no alert later, state "Waiting for work" | |
| A12 | Quick answer | Work ends, press "Stop" within 5 s | Overtime never shown | |
| A13 | Overtime after screen off | Work ends with the screen off, turn it on 2 min later | 0:00 and a red overtime of about -2:00 | |
| A14 | Defaults | `dconf reset -f /apps/harbour-202020/`, open settings | Work 20 min, break 20 s, repeat "Loop until stopped", type "Notification" | |
| A15 | Settings kept | Set work 25 min, close and reopen the app | Work 25 min | |
| A16 | Change during a phase | Work running, change work duration | Current phase ends at its old time; the next work uses the new duration | |
| A17 | Close during work | Work running, close the app; after the work time check `ps` via ssh | No alert, no `harbour-202020` process | |
| A18 | No autostart | Reboot the phone | The app does not start by itself | |

## B. Break alerts (`break-alerts`)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| B1 | Screen off during work | Start the 20 min work, minimize, screen off | Alert within 5 s of the end | |
| B2 | Break end | Break ends while looking away | Alert recognizable without looking (sound and/or vibration) | |
| B3 | Once | Repeat "Once", work ends | Sound plays once, state stays "Work" finished | |
| B4 | Loop until Stop | Repeat "Loop until stopped", work ends, press "Stop" after 30 s | Sound repeats for 30 s, stops on the press | |
| B5 | Notification, silent profile | Type "Notification", silent profile, work ends | No sound, "Work" still becomes finished | |
| B6 | Alarm, silent profile | Type "Alarm", silent profile, work ends | Alert is audible | |
| B7 | System alarm volume | Type "Alarm", lower the alarm volume in system settings, work ends | Alarm ringtone at the lower volume | |
| B8 | Alarm once | Type "Alarm", "Once", alarm length 30 s, work ends | Rings about 30 s, then silent; state stays "Work" finished | |
| B9 | Alarm length kept | Set alarm length 15 s, close and reopen the app | Alarm length 15 s | |
| B10 | Stop during loop | "Loop until stopped", break finished, press "Stop" | Sound stops at once, state "Waiting for work" | |
| B11 | Events list | After an alert, open the Events view | The app's notification is listed (see task 6.8) | |

## C. Language

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| C1 | Italian | System language Italian, walk through every state and the settings | No English or untranslated strings | |
| C2 | English | System language English (needs a reboot), same walk-through | No Italian or untranslated strings | |

## Notes

