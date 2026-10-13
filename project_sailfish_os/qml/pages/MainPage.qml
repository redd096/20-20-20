import QtQuick 2.0
import Sailfish.Silica 1.0

// Main page: current phase, remaining time, the main button and Stop.
// A pull-down menu opens the settings.
Page {
    id: page

    // CycleController, ConfigurationGroup and AlertPlayer, passed by the window.
    property var cycle
    property var settings
    property var alert

    allowedOrientations: Orientation.All

    // Human-readable name of a phase.
    function phaseText(phase) {
        switch (phase) {
        case "working": return qsTr("Working")
        case "workDone": return qsTr("Work finished")
        case "onBreak": return qsTr("On break")
        case "breakDone": return qsTr("Break finished")
        default: return qsTr("Stopped")
        }
    }

    // Label of the main button: what pressing it will do.
    function buttonText(phase) {
        switch (phase) {
        case "workDone": return qsTr("Start break")
        case "breakDone": return qsTr("Resume")
        default: return qsTr("Start")
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"), { settings: page.settings, alert: page.alert })
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
                text: page.phaseText(page.cycle.phase)
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeLarge
            }

            // Remaining time, only while a countdown is running.
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: page.cycle.counting
                text: page.cycle.remainingText
                font.pixelSize: Theme.fontSizeHuge * 2
            }

            Item { width: 1; height: Theme.paddingLarge }

            // Main button, hidden during a countdown (spec "break-cycle").
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: !page.cycle.counting
                preferredWidth: Theme.buttonWidthLarge
                text: page.buttonText(page.cycle.phase)
                onClicked: page.cycle.confirm()
            }

            // Stop is available in every phase except "idle".
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: page.cycle.phase !== "idle"
                preferredWidth: Theme.buttonWidthMedium
                text: qsTr("Stop")
                onClicked: page.cycle.stop()
            }
        }
    }
}
