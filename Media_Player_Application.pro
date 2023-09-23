QT += quick
QT += quick multimedia core
CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

HEADERS += \
    include/Player.h \
    include/Playlistmodel.h \
    include/Translation.h

SOURCES += \
    src/main.cpp \
    src/Player.cpp \
    src/Playlistmodel.cpp \
    src/Translation.cpp

RESOURCES += \
    assets/assets.qrc \
    qml/qml.qrc

LIBS += -L$$PWD/taglib -l:libtag.a
INCLUDEPATH += $$PWD/taglib/include
DEPENDPATH += $$PWD/taglib/include

TRANSLATIONS += assets/translation/translate_us.ts\
                assets/translation/translate_vn.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
