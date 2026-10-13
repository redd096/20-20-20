import QtQuick 2.0
import Sailfish.Silica 1.0

// Integer slider with - and + buttons on its sides.
//
// Like the sliders in Jolla Settings, the starting value is read once and a
// new value is reported only when a gesture ends (slider released, - or +
// pressed). There is no live binding to dconf: its change notifications
// arrive asynchronously and would move the slider back to older values.
Item {
    id: root

    property int minimumValue
    property int maximumValue
    // Distance between two allowed values; also the size of one - or + step.
    property int stepSize: 1
    // Read only when the component is created.
    property int initialValue
    property string label
    property string unit
    // Current integer value: the only one shown and reported.
    property int current

    // Emitted only for user changes, never while initializing.
    signal edited(int newValue)

    width: parent.width
    height: slider.height

    Component.onCompleted: {
        current = clamp(initialValue)
        slider.value = current
    }

    // Keeps a value inside the allowed range.
    function clamp(v) {
        return Math.max(minimumValue, Math.min(maximumValue, v))
    }

    // Applies a new value from the user and reports it if it changed.
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
        // Every press is one step. With "clicked", fast taps are grouped
        // into double clicks and some of them get lost.
        onPressed: root.setCurrent(root.current - root.stepSize)
    }

    Slider {
        id: slider
        anchors { left: minus.right; right: plus.left }
        leftMargin: Theme.paddingMedium
        rightMargin: Theme.paddingMedium
        minimumValue: root.minimumValue
        maximumValue: root.maximumValue
        stepSize: root.stepSize
        label: root.label
        valueText: (down ? Math.round(sliderValue) : root.current) + " " + root.unit
        // SliderBase updates value in its own handler, which runs before this one.
        onReleased: root.setCurrent(Math.round(value))
    }

    IconButton {
        id: plus
        anchors { right: parent.right; rightMargin: Theme.paddingSmall; verticalCenter: slider.verticalCenter }
        icon.source: "image://theme/icon-m-add"
        enabled: root.current < root.maximumValue
        onPressed: root.setCurrent(root.current + root.stepSize)
    }
}
