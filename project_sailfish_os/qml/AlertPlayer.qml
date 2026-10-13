import QtQuick 2.0
import Nemo.KeepAlive 1.2
import Nemo.Notifications 1.0
import QtMultimedia 5.6
import QtFeedback 5.0

// End-of-phase alert (spec "break-alerts"). Two alert types:
//
// - "notification": a critical notification with a sound. The system plays
//   it on the ringtone volume, so it respects silent mode and do not disturb.
// - "alarm": the app plays the sound itself. The launcher (src/harbour-202020.cpp)
//   routes every audio stream of this process to the PulseAudio "alarm" role,
//   so it rings even in silent mode. A silent notification is published as
//   well, to show the message and turn the screen on.
//
// Both types vibrate once when the alert starts. The mechanisms were chosen
// with a device spike, see docs/sailfish-spike.md.
Item {
    id: alert

    property string type: "notification"   // "notification" | "alarm"
    property string repeat: "once"          // "once" | "loop"
    // Volume of the "alarm" type, in percent.
    property int alarmVolume: 100

    // True while an alert is waiting for the user's confirmation.
    readonly property bool active: _phase !== ""
    // True while the sound keeps repeating.
    readonly property bool looping: active && repeat === "loop"

    // Phase that triggered the alert ("workDone" or "breakDone"), empty when idle.
    property string _phase: ""

    // Starts the alert for the phase that has just finished.
    function start(phase) {
        stop()
        _phase = phase
        vibra.start()
        // Start from a fresh notification: remove the previous one and forget
        // its id. Reusing the id of a notification the user has already
        // dismissed shows the banner but no new entry in Events.
        notification.close()
        notification.replacesId = 0
        if (type === "alarm") {
            // The sound comes from Audio; the notification is only visual.
            notification.sound = ""
            publishNotification(true)
            previewStop.stop()
            alarmSound.volume = toAudioVolume(alarmVolume)
            alarmSound.loops = repeat === "loop" ? Audio.Infinite : 1
            alarmSound.play()
        } else {
            notification.sound = notificationSoundFile
            publishNotification(true)
            if (repeat === "loop")
                notificationLoop.start()
        }
    }

    // Publishes (or re-publishes) the notification. The banner at the top of
    // the screen uses the preview texts: leaving them empty on repeats should
    // replay only the sound, without showing the banner again.
    function publishNotification(withBanner) {
        notification.previewSummary = withBanner ? notification.summary : ""
        notification.previewBody = withBanner ? notification.body : ""
        notification.publish()
    }

    // Plays the alarm sound for two seconds at the given volume, so the
    // user can hear a new volume setting. Ignored while an alert is active.
    function preview(volumePercent) {
        if (active)
            return
        alarmSound.stop()
        alarmSound.volume = toAudioVolume(volumePercent)
        alarmSound.loops = 1
        alarmSound.play()
        previewStop.restart()
    }

    // Audio.volume is linear; squaring the percentage gives steps that sound
    // more even to the ear.
    function toAudioVolume(percent) {
        var v = percent / 100
        return v * v
    }

    // Stops any sound. The notification stays in the Events view, like for
    // every other app, until the user removes it or the next alert replaces it.
    function stop() {
        _phase = ""
        notificationLoop.stop()
        alarmSound.stop()
        vibra.stop()
    }

    readonly property string notificationSoundFile: "/usr/share/sounds/jolla-ringtones/stereo/jolla-messagetone.ogg"

    Notification {
        id: notification
        appName: "20-20-20"
        appIcon: "harbour-202020"
        // Critical urgency turns the screen on and keeps one entry in Events.
        urgency: Notification.Critical
        summary: alert._phase === "workDone" ? qsTr("Time for a break") : qsTr("Break finished")
        body: alert._phase === "workDone" ? qsTr("Look at something about 20 feet (6 m) away.")
                                          : qsTr("You can go back to the screen.")
    }

    // Loop for the "notification" type: publishing the same notification
    // again replaces it and plays its sound again. The ringtone lasts 3.2 s.
    Timer {
        id: notificationLoop
        interval: 4000
        repeat: true
        onTriggered: alert.publishNotification(false)
    }

    // Sound for the "alarm" type (8.4 s long), on the alarm stream.
    Audio {
        id: alarmSound
        source: "/usr/share/sounds/jolla-ringtones/stereo/jolla-alarm.ogg"
    }

    // Ends a volume preview.
    Timer {
        id: previewStop
        interval: 2000
        onTriggered: if (!alert.active) alarmSound.stop()
    }

    HapticsEffect {
        id: vibra
        intensity: 1.0
        duration: 800
    }

    // Without KeepAlive the device would suspend and the loop would stop
    // while the screen is off.
    KeepAlive {
        enabled: alert.looping
    }
}
