import QtQuick 2.0
import Sailfish.Silica 1.0

// Cover: shows the remaining time, or the state when no countdown is
// running, and one action that depends on the state.
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

    // One action, like the main button of the main page: start the next
    // phase while waiting, Stop during work and break (it also stops the
    // alert). "Restart work" is left to the main page.
    CoverActionList {
        CoverAction {
            readonly property bool waiting: cover.cycle.phase === "waitWork"
                                            || cover.cycle.phase === "waitBreak"
            iconSource: waiting ? "image://theme/icon-cover-play" : "image://theme/icon-cover-cancel"
            onTriggered: waiting ? cover.cycle.confirm() : cover.cycle.stop()
        }
    }
}
