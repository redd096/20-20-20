# Il nome in TARGET deve coincidere con quello del file QML principale,
# del file .desktop, delle icone e del pacchetto RPM.
TARGET = harbour-202020

CONFIG += sailfishapp

SOURCES += src/harbour-202020.cpp

DISTFILES += qml/harbour-202020.qml \
    qml/CycleController.qml \
    qml/pages/MainPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/StepSlider.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-202020.spec \
    rpm/harbour-202020.changes \
    harbour-202020.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172
