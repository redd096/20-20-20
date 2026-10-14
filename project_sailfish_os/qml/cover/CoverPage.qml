import QtQuick 2.0
import Sailfish.Silica 1.0

// Passive cover: shows the remaining time, or the state when no countdown
// is running, with no actions.
CoverBackground {
    id: cover

    // CycleController, passed by the window.
    property var cycle

    // Short status when no countdown is running, empty otherwise.
    function statusText(phase) {
        switch (phase) {
        case "workDone": return qsTr("Time for a break")
        case "breakDone": return qsTr("Break finished")
        case "waitBreak": return qsTr("Waiting for break")
        default: return ""
        }
    }

    Column {
        anchors.centerIn: parent
        width: parent.width - 2 * Theme.paddingLarge
        spacing: Theme.paddingMedium

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "20-20-20"
            color: Theme.secondaryColor
        }
        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            visible: cover.cycle.counting
            text: cover.cycle.remainingText
            font.pixelSize: Theme.fontSizeHuge
        }
        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            visible: text !== ""
            text: cover.statusText(cover.cycle.phase)
            color: Theme.highlightColor
        }
    }
}
