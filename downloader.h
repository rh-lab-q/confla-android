#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include <QObject>
#include <QNetworkReply>
#include <QTime>
#include <QFile>
#include <QUrl>
#include <QQueue>
#include <QString>
#include "customnetworkaccessmanager.h"

class DownloadPair {
public:
    QUrl url;
    QUrl local;
};


class Downloader : public QObject
{
    Q_OBJECT

public:
    Downloader(QObject *parent = 0);


    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QString errorString READ getMErrorString NOTIFY errorStringChanged)

    Q_INVOKABLE void append(const QUrl remote, QUrl local);
    int count();
    Q_INVOKABLE void cancel();

    QString getMErrorString () { return m_errorString; }

signals:
    void countChanged();
    void errorStringChanged();

private slots:
    void downloadNext();
    void downloadFinished();
    void downloadReadyRead();

private:

    QQueue<DownloadPair> m_downloadlist;


    QNetworkAccessManager manager;
    QFile output;
    QNetworkReply *currentDownload;
    QString m_userAgent;
    QString m_errorString;

    bool m_cancel;
//    QStringList downloadList;
//    QStringList localList;
//    QString customUserAgent;

//    char *pathToLocale;

//    int downloadedCount;
//    int totalCount;



};

#endif // DOWNLOADER_H
