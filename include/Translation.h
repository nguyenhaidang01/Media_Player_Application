#ifndef TRANSLATION_H
#define TRANSLATION_H

#include <QObject>
#include <QTranslator>
#include <QGuiApplication>

class Translation : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString updateText READ getEmptyString  NOTIFY languageChanged)

public:
    Translation(QObject *parent = nullptr);
    Q_INVOKABLE void selectLanguage(QString language);
    QString getEmptyString();

signals:
    void languageChanged();

private:
    QTranslator translator;
    QGuiApplication *m_app;
    QString m_updateText;
};

#endif // TRANSLATION_H
