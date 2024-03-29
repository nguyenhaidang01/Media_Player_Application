#include <QMediaService>
#include <QMediaPlaylist>
#include <QMediaMetaData>
#include <QObject>
#include <QFileInfo>
#include <QTime>
#include <QDir>
#include <QStandardPaths>

#include "include/Player.h"
#include "include/Playlistmodel.h"

Player::Player(QObject *parent)
    : QObject(parent)
{
    m_player = new QMediaPlayer(this);
    m_playlist = new QMediaPlaylist(this);
    m_player->setPlaylist(m_playlist);
    m_playlistModel = new PlaylistModel(this);
    open();
    if (!m_playlist->isEmpty()) {
        m_playlist->setCurrentIndex(0);
    }
}

void Player::open()
{
    QDir directory(QStandardPaths::standardLocations(QStandardPaths::MusicLocation)[0]);
    QFileInfoList musics = directory.entryInfoList(QStringList() << "*.mp3",QDir::Files);
    QList<QUrl> urls;
    for (int i = 0; i < musics.length(); i++){
        urls.append(QUrl::fromLocalFile(musics[i].absoluteFilePath()));
    }
    addToPlaylist(urls);
}

void Player::addToPlaylist(const QList<QUrl> &urls)
{
    for (auto &url: urls) {

        m_playlist->addMedia(url);

        const char * path = url.path().toStdString().c_str();
        path++;

        FileRef f(path);

        Tag *tag = f.tag();

        if(tag){
            Song song(QString::fromWCharArray(tag->title().toCWString()),
                      QString::fromWCharArray(tag->artist().toCWString()),url.toDisplayString(),
                      getAlbumArt(dynamic_cast<TagLib::MPEG::File*>(f.file())));
            m_playlistModel->addSong(song);
        }
    }
}

QString Player::getTimeInfo(qint64 currentInfo)
{
    QString tStr = "00:00";
    currentInfo = currentInfo/1000;
    qint64 durarion = m_player->duration()/1000;
    if (currentInfo || durarion) {
        QTime currentTime((currentInfo / 3600) % 60, (currentInfo / 60) % 60,
                          currentInfo % 60, (currentInfo * 1000) % 1000);
        QTime totalTime((durarion / 3600) % 60, (m_player->duration() / 60) % 60,
                        durarion % 60, (m_player->duration() * 1000) % 1000);
        QString format = "mm:ss";
        if (durarion > 3600)
            format = "hh::mm:ss";
        tStr = currentTime.toString(format);
    }
    return tStr;
}
QString Player::getAlbumArt(MPEG::File* mpegFile)
{
    static const char *IdPicture = "APIC" ;

    TagLib::ID3v2::Tag *id3v2tag = mpegFile->ID3v2Tag();
    TagLib::ID3v2::FrameList Frame ;
    TagLib::ID3v2::AttachedPictureFrame *PicFrame ;
    void *SrcImage ;
    unsigned long Size ;

    FILE *jpegFile;
    auto name = mpegFile->name().toString() + ".jpg";
    jpegFile = fopen(name.toCString(),"wb");
    qDebug() << name.toCString();
    if ( id3v2tag )
    {

        // picture frame
        Frame = id3v2tag->frameListMap()[IdPicture] ;
        qDebug() << "Frame";
        if (!Frame.isEmpty() )
        {
            qDebug() << "Frame not empty";
            for(TagLib::ID3v2::FrameList::ConstIterator it = Frame.begin(); it != Frame.end(); ++it)
            {
                PicFrame = static_cast<TagLib::ID3v2::AttachedPictureFrame*>(*it) ;
                //if ( PicFrame->type() == (TagLib::ID3v2::AttachedPictureFrame::FrontCover))
                {
                    // extract image (in it’s compressed form)
                    Size = PicFrame->picture().size() ;
                    qDebug() << "Size : " << Size ;
                    SrcImage = malloc ( Size ) ;
                    if ( SrcImage )
                    {
                        memcpy ( SrcImage, PicFrame->picture().data(), Size ) ;
                        fwrite(SrcImage,Size,1, jpegFile);
                        fclose(jpegFile);
                        free( SrcImage ) ;
                        qDebug() << "source : " << QUrl::fromLocalFile(name.toCString()).toDisplayString();
                        return QUrl::fromLocalFile(name.toCString()).toDisplayString();

                    }

                }
            }
        }
    }
    else
    {
        qDebug() <<"id3v2 not present";
        return "qrc:/Image/album_art.png";
    }
    return "qrc:/Image/album_art.png";
}
