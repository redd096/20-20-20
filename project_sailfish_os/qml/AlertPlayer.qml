import QtQuick 2.0
import QtMultimedia 5.6
import Nemo.Configuration 1.0
import Nemo.DBus 2.0
import Nemo.KeepAlive 1.2
import Nemo.Notifications 1.0
import QtFeedback 5.0

// End-of-phase alert (spec "break-alerts"). Three alert types:
//
// - "sound": the app plays the sound itself (QtMultimedia, Sailjail "Audio"
//   permission), on the media volume. Muted in silent mode by the system and
//   in do not disturb by the app. The notification is silent and published
//   once, so the banner is shown once even in a loop.
// - "notification": a critical notification with a sound. The system plays
//   it on the ringtone volume, so it respects silent mode and do not disturb.
//   The loop publishes it again, so the banner is shown at every repeat.
// - "alarm": the system alarm, played by the feedback daemon ngfd (event
//   "clock"): the user's alarm tone, at the alarm volume, with the alarm
//   vibration, even in silent mode. It fades in over 20 s and repeats until
//   the app stops it. A silent notification is published as well, to show
//   the message and turn the screen on.
//
// The "sound" and "notification" types vibrate once when the alert starts; the "alarm"
// type uses the vibration of the ngfd event. The mechanisms were chosen with
// device spikes, see docs/sailfish-spike.md.
Item {
    id: alert

    property string type: "sound"          // "sound" | "notification" | "alarm"
    property string repeat: "once"          // "once" | "loop"
    // How long the "alarm" type rings with the "once" repeat, in seconds.
    property int alarmOnceSeconds: 30

    // True from the end of a countdown until the user presses Stop.
    readonly property bool active: _phase !== ""
    // True while the sound keeps repeating.
    readonly property bool looping: active && repeat === "loop"

    // Phase that triggered the alert ("workDone" or "breakDone"), empty when idle.
    property string _phase: ""
    // Id that ngfd returned for the alarm being played, 0 when none.
    property var _alarmId: 0
    // Increased at every start() and stop(), so that a late answer to Play
    // can tell whether its alarm is still wanted.
    property int _alarmRequest: 0

    // Starts the alert for the phase that has just finished.
    function start(phase) {
        stop()
        _phase = phase
        // Start from a fresh notification: remove the previous one and forget
        // its id. Reusing the id of a notification the user has already
        // dismissed shows the banner but no new entry in Events.
        notification.close()
        notification.replacesId = 0
        if (type === "alarm") {
            // The sound comes from ngfd; the notification is only visual.
            notification.sound = ""
            publishNotification()
            playAlarm()
            if (repeat === "once")
                alarmOnceStop.restart()
        } else if (type === "sound") {
            // The sound comes from the app; the notification is only visual.
            vibra.start()
            notification.sound = ""
            publishNotification()
            playSound()
            if (repeat === "loop")
                notificationLoop.start()
        } else {
            vibra.start()
            notification.sound = notificationSoundFile
            publishNotification()
            if (repeat === "loop")
                notificationLoop.start()
        }
    }

    // Publishes (or re-publishes) the notification. The banner at the top of
    // the screen uses the preview texts. Every publish shows the banner and
    // plays the sound: empty preview texts, tried to replay only the sound,
    // drew an empty white banner instead.
    function publishNotification() {
        notification.previewSummary = notification.summary
        notification.previewBody = notification.body
        notification.publish()
    }

    // Plays the sound of the "sound" type, unless do not disturb is on. The
    // system mutes it in silent mode, but not in do not disturb.
    function playSound() {
        if (!doNotDisturb.value)
            appSound.play()
    }

    // Asks ngfd to play the system alarm. The answer arrives later: if the
    // alert was stopped (or restarted) in the meantime, stop that alarm at once.
    function playAlarm() {
        var request = ++_alarmRequest
        ngfd.call("Play", ["clock", {}], function (id) {
            if (request === alert._alarmRequest)
                alert._alarmId = id
            else
                alert.stopAlarm(id)
        }, function (error) {
            console.warn("ngfd Play failed:", error)
        })
    }

    // Stops one ngfd event. Only the D-Bus connection that started it may stop it.
    function stopAlarm(id) {
        ngfd.typedCall("Stop", [{ "type": "u", "value": id }], undefined, function (error) {
            console.warn("ngfd Stop failed:", error)
        })
    }

    // Stops any sound. The notification stays in the Events view, like for
    // every other app, until the user removes it or the next alert replaces it.
    function stop() {
        _phase = ""
        _alarmRequest++
        if (_alarmId !== 0) {
            stopAlarm(_alarmId)
            _alarmId = 0
        }
        alarmOnceStop.stop()
        notificationLoop.stop()
        appSound.stop()
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

    // Sound of the "sound" type. Loaded when the app starts, so the first
    // alert plays without delay.
    Audio {
        id: appSound
        source: alert.notificationSoundFile
    }

    // Do not disturb, as set by the system (lipstick). If the sandbox does not
    // allow reading it, it stays false and the "sound" type always rings.
    ConfigurationValue {
        id: doNotDisturb
        key: "/lipstick/do_not_disturb"
        defaultValue: false
    }

    // Loop for the "sound" and "notification" types. With "sound" only the
    // sound is played again; checking do not disturb at every repeat mutes
    // the next ones as soon as it is turned on. With "notification",
    // publishing the same notification again replaces it, shows the banner
    // and plays its sound again. The sound lasts 3.2 s: every 4 s keeps a
    // short pause between plays.
    Timer {
        id: notificationLoop
        interval: 4000
        repeat: true
        onTriggered: {
            if (alert.type === "sound")
                alert.playSound()
            else
                alert.publishNotification()
        }
    }

    // The ngfd alarm always repeats: with the "once" repeat it is stopped
    // after alarmOnceSeconds. The alert stays active until the user presses Stop.
    Timer {
        id: alarmOnceStop
        interval: alert.alarmOnceSeconds * 1000
        onTriggered: {
            if (alert._alarmId !== 0) {
                alert.stopAlarm(alert._alarmId)
                alert._alarmId = 0
            }
        }
    }

    // The feedback daemon on the system bus. Its introspection data names the
    // interface "...Backend" with the signature sa(sv), but the daemon really
    // answers on this interface with Play(s, a{sv}). ngfd cancels the events
    // of a client that disconnects, so the app's connection must stay open
    // while the alarm rings, which it does as long as the app runs.
    DBusInterface {
        id: ngfd
        bus: DBus.SystemBus
        service: "com.nokia.NonGraphicFeedback1.Backend"
        path: "/com/nokia/NonGraphicFeedback1"
        iface: "com.nokia.NonGraphicFeedback1"
    }

    HapticsEffect {
        id: vibra
        intensity: 1.0
        duration: 800
    }

    // Without KeepAlive the device would suspend while the screen is off:
    // the notification loop would stop, and the timer that ends a "once"
    // alarm would fire late.
    KeepAlive {
        enabled: alert.looping || alarmOnceStop.running
    }
}
