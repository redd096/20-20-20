import QtQuick 2.0
import Sailfish.Silica 1.0

// Slider intero con pulsanti - e + ai lati. Come in Jolla Settings, il valore
// iniziale si legge una volta e si salva solo a gesto concluso (rilascio dello
// slider o pressione di - e +): niente legame continuo con dconf, le cui
// notifiche asincrone riporterebbero indietro il valore.
Item {
    id: root

    property int minimumValue
    property int maximumValue
    // Letto solo alla creazione.
    property int initialValue
    property string label
    property string unit
    // Valore intero corrente, l'unico mostrato e salvato.
    property int current

    signal edited(int newValue)

    width: parent.width
    height: slider.height

    Component.onCompleted: {
        current = clamp(initialValue)
        slider.value = current
    }

    function clamp(v) {
        return Math.max(minimumValue, Math.min(maximumValue, v))
    }

    function setCurrent(v) {
        v = clamp(v)
        slider.value = v
        if (v === current)
            return
        current = v
        edited(v)
    }

    IconButton {
        id: minus
        anchors { left: parent.left; leftMargin: Theme.paddingSmall; verticalCenter: slider.verticalCenter }
        icon.source: "image://theme/icon-m-remove"
        enabled: root.current > root.minimumValue
        // Ogni pressione conta un passo: con clicked i tocchi rapidi
        // vengono raggruppati in doppi clic e alcuni si perdono.
        onPressed: root.setCurrent(root.current - 1)
    }

    Slider {
        id: slider
        anchors { left: minus.right; right: plus.left }
        leftMargin: Theme.paddingMedium
        rightMargin: Theme.paddingMedium
        minimumValue: root.minimumValue
        maximumValue: root.maximumValue
        stepSize: 1
        label: root.label
        valueText: (down ? Math.round(sliderValue) : root.current) + " " + root.unit
        // Il gestore di SliderBase aggiorna value prima di questo.
        onReleased: root.setCurrent(Math.round(value))
    }

    IconButton {
        id: plus
        anchors { right: parent.right; rightMargin: Theme.paddingSmall; verticalCenter: slider.verticalCenter }
        icon.source: "image://theme/icon-m-add"
        enabled: root.current < root.maximumValue
        onPressed: root.setCurrent(root.current + 1)
    }
}
