import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages"
import "cover"

// Application window: owns the settings, the cycle and the alert, and passes
// them to the pages.
ApplicationWindow {
    id: app

    // Brings the app to the foreground on the main page, so the phase and the
    // main button are visible as soon as the alert starts. With the device
    // locked, the app is shown right after unlocking.
    function showMainPage() {
        if (pageStack.depth > 1)
            pageStack.pop(null, PageStackAction.Immediate)
        activate()
    }

    // Settings stored in dconf under /apps/harbour-202020.
    // Remove them with: dconf reset -f /apps/harbour-202020/
    ConfigurationGroup {
        id: appSettings
        path: "/apps/harbour-202020"
        property int workMinutes: 20
        property int breakSeconds: 20
        property string alertRepeat: "once"         // "once" | "loop"
        property string alertType: "notification"   // "notification" | "alarm"
        property int alarmOnceSeconds: 30           // seconds, 5-60
        // Testing only, not shown in the UI: when above 0, the work phase
        // lasts this many seconds instead of workMinutes. See docs/sailfish.md.
        property int testWorkSeconds: 0
    }

    AlertPlayer {
        id: alertPlayer
        type: appSettings.alertType === "alarm" ? "alarm" : "notification"
        repeat: appSettings.alertRepeat === "loop" ? "loop" : "once"
        alarmOnceSeconds: Math.max(5, Math.min(60, appSettings.alarmOnceSeconds))
    }

    CycleController {
        id: cycleController
        // Clamp the stored values, in case dconf was edited by hand.
        workSeconds: appSettings.testWorkSeconds > 0
                     ? appSettings.testWorkSeconds
                     : Math.max(1, Math.min(120, appSettings.workMinutes)) * 60
        breakSeconds: Math.max(5, Math.min(300, appSettings.breakSeconds))
        onPhaseFinished: {
            alertPlayer.start(phase)
            app.showMainPage()
        }
        // Stop: the alert must not outlive the phase that started it.
        onPhaseChanged: if (phase !== "workDone" && phase !== "breakDone") alertPlayer.stop()
    }

    initialPage: Component { MainPage { cycle: cycleController; settings: appSettings } }
    cover: Component { CoverPage { cycle: cycleController } }
    allowedOrientations: defaultAllowedOrientations
}
