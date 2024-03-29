import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1
import QtMultimedia 5.9
Item {
    Text {
        id: audioTitle
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        text: album_art_view.currentItem.myData.title
        color: "white"
        font.pixelSize: 36
        onTextChanged: {
            textChangeAni.targets = [audioTitle,audioSinger]
            textChangeAni.restart()
        }
    }
    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: audioTitle.left
        text: album_art_view.currentItem.myData.singer
        color: "white"
        font.pixelSize: 32
    }

    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }
    Text {
        id: audioCount
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        text: album_art_view.count
        color: "white"
        font.pixelSize: 36
    }
    Image {
        anchors.top: parent.top
        anchors.topMargin: 23
        anchors.right: audioCount.left
        anchors.rightMargin: 10
        source: "qrc:/images/music.png"
    }

    Component {
        id: appDelegate
        Item {
            property variant myData: model
            width: 400; height: 400
            scale: PathView.iconScale
            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 20
                anchors.horizontalCenter: parent.horizontalCenter
                source: album_art
            }

            MouseArea {
                anchors.fill: parent
                onClicked: album_art_view.currentIndex = index
            }
        }
    }

    PathView {
        id: album_art_view
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - 1100)/2
        anchors.top: parent.top
        anchors.topMargin: 300
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: myModel
        delegate: appDelegate
        pathItemCount: 3
        path: Path {
            startX: 10
            startY: 50
            PathAttribute { name: "iconScale"; value: 0.5 }
            PathLine { x: 550; y: 50 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathLine { x: 1100; y: 50 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
        onCurrentIndexChanged: {
            player.playlist.currentIndex = currentIndex
        }
    }
    //Progress
    Text {
        id: currentTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.right: progressBar.left
        anchors.rightMargin: 20
        text: utility.getTimeInfo(player.position)
        color: "white"
        font.pixelSize: 24
    }
    Slider{
        id: progressBar
        width: 1491 - 675*playlist.position
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 245
        anchors.horizontalCenter: parent.horizontalCenter
        from: 0
        to: player.duration
        value: player.position
        background: Rectangle {
            x: progressBar.leftPadding
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: progressBar.availableWidth
            height: implicitHeight
            radius: 2
            color: "gray"

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                color: "white"
                radius: 2
            }
        }
        handle: Image {
            anchors.verticalCenter: parent.verticalCenter
            x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            source: "qrc:/images/point.png"
            Image {
                anchors.centerIn: parent
                source: "qrc:/images/center_point.png"
            }
        }
        onMoved: {
            if (player.seekable){
                player.setPosition(Math.floor(position*player.duration))
            }
        }
    }
    Text {
        id: totalTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: progressBar.right
        anchors.leftMargin: 20
        text: utility.getTimeInfo(player.duration)
        color: "white"
        font.pixelSize: 24
    }
    //Media control
    SwitchButton {
        id: shuffer
        property bool isOn: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: currentTime.left
        icon_off: "qrc:/images/shuffle.png"
        icon_on: "qrc:/images/shuffle-1.png"
        status: isOn ? 1 : 0
        onClicked: {
            isOn =!isOn
            player.playlist.playbackMode = isOn? Playlist.Random:Playlist.Loop
            if(repeater.isOn) player.playlist.playbackMode = Playlist.CurrentItemInLoop
        }
    }

    ButtonControl {
        id: prev
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.right: play.left
        icon_default: "qrc:/images/prev.png"
        icon_pressed: "qrc:/images/hold-prev.png"
        icon_released: "qrc:/images/prev.png"
        onClicked: {
            if(repeater.isOn && shuffer.isOn) {
                player.playlist.playbackMode = Playlist.Random
                player.playlist.previous()
                player.playlist.playbackMode = Playlist.CurrentItemInLoop
            } else {
                player.playlist.previous()
            }
        }
    }

    ButtonControl {
        id: play
        property bool isOn: false
        anchors.verticalCenter: prev.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        icon_default: player.state == MediaPlayer.PlayingState ?  "qrc:/images/pause.png" : "qrc:/images/play.png"
        icon_pressed: player.state == MediaPlayer.PlayingState ?  "qrc:/images/hold-pause.png" : "qrc:/images/hold-play.png"
        icon_released: player.state == MediaPlayer.PlayingState ?  "qrc:/images/pause.png" : "qrc:/images/play.png"
        onClicked: {
            isOn =!isOn
            isOn? player.play(): player.pause()
        }
        Connections {
            target: player
            onStateChanged:{
                play.source = player.state == MediaPlayer.PlayingState ?  "qrc:/images/pause.png" : "qrc:/images/play.png"
            }
        }
    }

    ButtonControl {
        id: next
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: play.right
        icon_default: "qrc:/images/next.png"
        icon_pressed: "qrc:/images/hold-next.png"
        icon_released: "qrc:/images/next.png"
        onClicked: {
            if(repeater.isOn && shuffer.isOn) {
                player.playlist.playbackMode = Playlist.Random
                player.playlist.next()
                player.playlist.playbackMode = Playlist.CurrentItemInLoop
            } else {
                player.playlist.next()
            }
        }
    }

    SwitchButton {
        id: repeater
        property bool isOn: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.right: totalTime.right
        icon_on: "qrc:/images/repeat1_hold.png"
        icon_off: "qrc:/images/repeat.png"
        status: isOn ? 1 : 0
        onClicked: {
            isOn =!isOn
            player.playlist.playbackMode = isOn? Playlist.CurrentItemInLoop:Playlist.Loop
            if(!isOn && shuffer.isOn) player.playlist.playbackMode = Playlist.Random
        }
    }

    Connections{
        target: player.playlist
        onCurrentIndexChanged: {
            album_art_view.currentIndex = index;
        }
    }
}
