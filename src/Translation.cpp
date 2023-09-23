#include "include/Translation.h"

Translation::Translation(QObject *parent)
    : QObject(parent)
{
    translator.load(":/translation/translate_us.qm");
    m_app->installTranslator(&translator);
}

void Translation::selectLanguage(QString language)
{
    if(language == "vn") {
      translator.load(":/translation/translate_vn.qm");
        m_app->installTranslator(&translator);
    } else {
       translator.load(":/translation/translate_us.qm");
       m_app->installTranslator(&translator);
    }
    emit languageChanged();
}

QString Translation::getEmptyString()
{
    return "";
}

