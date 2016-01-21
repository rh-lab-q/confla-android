#include "customnetworkaccessmanager.h"

CustomNetworkAccessManager::CustomNetworkAccessManager(QObject *parent) : QNetworkAccessManager(parent)
{
    m_userAgent = " Mozilla/5.0 (Linux; U; Android; Mobile; rv:20.0) Gecko/20.0 Firefox/20.0 DevConf 0.2+";
}
