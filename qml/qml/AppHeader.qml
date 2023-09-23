import QtQuick 2.0

Item {
    property bool isVnFlag: false
    Image {
        id: headerItem
        source: "qrc:/images/title.png"
        SwitchButton {
            id: playlist_button
            property bool isOn: false
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            icon_off: "qrc:/images/drawer.png"
            icon_on: "qrc:/images/back.png"
            status: isOn ? 1 : 0
            onClicked: {
                isOn =! isOn
                isOn? playlist.open(): playlist.close()
            }
        }
        Text {
            anchors.left: playlist_button.right
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            text:  qsTr("Playlist") + translator.updateText
            color: "white"
            font.pixelSize: 32
        }
        Text {
            id: headerTitleText
            text: qsTr( "Media Player") + translator.updateText
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }
        Image {
            id: vn_flag
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            width: 50
            height: 50
            source: "qrc:/images/vn.png"
            Rectangle{
                width: 50
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                border.color: isVnFlag? "#FFD700" : "gray"
                border.width: 3
                color: "transparent"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    isVnFlag = true
                    translator.selectLanguage("vn");
                }
            }
        }
        Image {
            id: us_flag
            anchors.right: vn_flag.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 50
            height: 50
            source: "qrc:/images/us.png"
            Rectangle{
                width: 50
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                border.color: isVnFlag? "gray" : "#FFD700"
                border.width: 3
                color: "transparent"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    isVnFlag = false
                    translator.selectLanguage("us");
                }
            }
        }
    }
}

