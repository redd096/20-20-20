# The name in TARGET must match the main QML file, the .desktop file,
# the icons and the RPM package name.
TARGET = harbour-202020

CONFIG += sailfishapp

SOURCES += src/harbour-202020.cpp

DISTFILES += qml/harbour-202020.qml \
    qml/CycleController.qml \
    qml/AlertPlayer.qml \
    qml/pages/MainPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/StepSlider.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-202020.spec \
    rpm/harbour-202020.changes \
    harbour-202020.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172
