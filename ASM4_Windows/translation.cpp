#include "translation.h"

Translation::Translation(QObject *parent)
    : QObject(parent)
{
    translator.load(":/translate_us.qm");
    m_app->installTranslator(&translator);
}

void Translation::selectLanguage(QString language)
{
    if(language=="vn") {
      translator.load(":/Translate/translate_vn.qm");
        m_app->installTranslator(&translator);
    } else {
       translator.load(":/Translate/translate_us.qm");
       m_app->installTranslator(&translator);
    }
    emit languageChanged();
}

QString Translation::getEmptyString()
{
    return "";
}

