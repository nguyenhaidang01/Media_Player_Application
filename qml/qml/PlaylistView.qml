import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1

Drawer {
    id: drawer
    property alias mediaPlaylist: mediaPlaylist
    interactive: false
    modal: false
    background: Rectangle {
        id: playList_bg
        anchors.fill: parent
        color: "transparent"
    }
    ListView {
        id: mediaPlaylist
        anchors.fill: parent
        model: myModel
        clip: true
        spacing: 2
        currentIndex: 0
        delegate: MouseArea {
            property variant myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height
            Image {
                id: playlistItem
                width: 675
                height: 193
                source: "qrc:/images/playlist.png"
                opacity: 0.5
            }
            Text {
                text: title
                anchors.fill: parent
                anchors.leftMargin: 70
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 32
            }
            onClicked: {
                player.playlist.currentIndex = index
            }
            onPressed: {
                playlistItem.source = "qrc:/images/hold.png"
            }
            onReleased: {
                playlistItem.source = "qrc:/images/playlist.png"
            }
            onCanceled: {
                playlistItem.source = "qrc:/images/playlist.png"
            }
        }
        highlight: Image {
            source: "qrc:/images/playlist_item.png"
            Image {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/playing.png"
            }
        }
        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
            policy: ScrollBar.AlwaysOn
        }
    }

    Connections{
        target: player.playlist
        onCurrentIndexChanged: {
            mediaPlaylist.currentIndex = index;
        }
    }
}
