QT += quick multimedia core
CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        player.cpp \
        playlistmodel.cpp \
        translation.cpp

RESOURCES += qml.qrc \
    resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =


#LIBS += -ltag

LIBS += -L$$PWD/lib -lTaglib

INCLUDEPATH += $$PWD/lib/include
DEPENDPATH += $$PWD/lib/include

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

TRANSLATIONS += translate_us.ts\
                translate_vn.ts

HEADERS += \
    player.h \
    playlistmodel.h \
    playlistmodel.h \
    translation.h
