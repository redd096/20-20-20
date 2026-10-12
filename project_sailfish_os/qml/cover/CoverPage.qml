import QtQuick 2.0
import Sailfish.Silica 1.0

// Cover passiva: solo stato e tempo rimanente, nessuna azione.
CoverBackground {
    id: cover

    property var cycle

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
            visible: !cover.cycle.counting && cover.cycle.phase !== "idle"
            text: cover.cycle.phase === "workDone" ? qsTr("Time for a break") : qsTr("Break finished")
            color: Theme.highlightColor
        }
    }
}
