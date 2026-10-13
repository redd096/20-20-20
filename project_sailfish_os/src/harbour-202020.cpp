#include <QtGlobal>
#include <sailfishapp.h>

int main(int argc, char *argv[])
{
    // Route every audio stream of this process to the PulseAudio "alarm"
    // role, so the "alarm" alert type rings even in silent mode and do not
    // disturb. QML's Audio.audioRole is ignored by Qt 5.6 on Sailfish OS.
    // Notifications are played by the system, not by this process, so they
    // keep following the ringtone volume. See docs/sailfish-spike.md.
    qputenv("PULSE_PROP", "media.role=alarm");
    qputenv("PULSE_PROP_OVERRIDE", "media.role=alarm");

    // Loads qml/harbour-202020.qml in a full-screen view.
    return SailfishApp::main(argc, argv);
}
