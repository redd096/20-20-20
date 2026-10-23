import QtQuick 2.0
import Sailfish.Silica 1.0

// Main page: current state, remaining time or overtime, and the commands
// of the current state.
// A pull-down menu opens the settings.
Page {
    id: page

    // CycleController and ConfigurationGroup, passed by the window.
    property var cycle
    property var settings

    allowedOrientations: Orientation.All

    // Name of the visible state (spec "break-cycle"): running and expired
    // phases share the same name. A long break has its own name (spec "pomodoro").
    function stateText(phase) {
        switch (phase) {
        case "working":
        case "workDone": return qsTr("Work")
        case "waitBreak": return qsTr("Waiting for break")
        case "onBreak":
        case "breakDone": return page.cycle.longBreak ? qsTr("Long break") : qsTr("Break")
        default: return qsTr("Waiting for work")
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                visible: page.settings.pomodoro
                text: qsTr("Reset counter")
                onClicked: page.cycle.resetCounter()
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"), { settings: page.settings })
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader { title: "20-20-20" }

            Label {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                text: page.stateText(page.cycle.phase)
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeLarge
            }

            // Overtime, in red, shown 10 s after the countdown has expired
            // (spec "break-cycle", "Overtime"). It keeps its space when
            // hidden, so the time below does not jump when it appears.
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: page.cycle.counting || page.cycle.expired
                opacity: page.cycle.overtimeSeconds >= 10 ? 1.0 : 0.0
                Behavior on opacity { FadeAnimator {} }
                text: page.cycle.overtimeText
                color: Theme.errorColor
                font.pixelSize: Theme.fontSizeHuge
            }

            // Remaining time while a countdown runs, 0:00 once it has expired.
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: page.cycle.counting || page.cycle.expired
                text: page.cycle.remainingText
                font.pixelSize: Theme.fontSizeHuge * 2
            }

            Item { width: 1; height: Theme.paddingLarge }

            // Main button of the waiting states: Start, or Start break.
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: page.cycle.phase === "waitWork" || page.cycle.phase === "waitBreak"
                preferredWidth: Theme.buttonWidthLarge
                text: page.cycle.phase === "waitBreak" ? qsTr("Start break") : qsTr("Start")
                onClicked: page.cycle.confirm()
            }

            // Second choice while waiting for the break: skip it.
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: page.cycle.phase === "waitBreak"
                preferredWidth: Theme.buttonWidthMedium
                text: qsTr("Restart work")
                onClicked: page.cycle.restartWork()
            }

            // Stop is the only command during work and break, running or
            // expired: it ends the phase and silences the alert.
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: page.cycle.inWork || page.cycle.inBreak
                preferredWidth: Theme.buttonWidthLarge
                text: qsTr("Stop")
                onClicked: page.cycle.stop()
            }
        }
    }

    // Pomodoro work counter at the bottom of the page, like in Minidoro:
    // works done / works before the long break.
    Label {
        anchors { bottom: parent.bottom; bottomMargin: Theme.paddingLarge * 2; horizontalCenter: parent.horizontalCenter }
        visible: page.settings.pomodoro
        text: page.cycle.worksDone + "/" + page.cycle.longBreakAfter
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeLarge
    }
}
