#include "downloader.h"
#include <QCoreApplication>
#include <QUrl>
#include <QNetworkRequest>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QFileInfo>
#include <QFile>
#include <QDir>
#include <QQueue>
#include <QTimer>
#include <QStandardPaths>
#include "customnetworkaccessmanager.h"


Downloader::Downloader(QObject *parent) : QObject(parent) {
    m_userAgent = " Mozilla/5.0 (Linux; U; Android; Mobile; rv:20.0) Gecko/20.0 Firefox/20.0 DevConf 0.2+";
    m_cancel = false;
}

void Downloader::append(const QUrl url, QUrl local) {
    DownloadPair p;
    p.url = url;
    p.local = local;
    if (m_downloadlist.isEmpty()) {
            QTimer::singleShot(1000, this, SLOT(downloadNext()));
    }
    m_downloadlist.enqueue(p);


    m_errorString = "";
    errorStringChanged();

    emit countChanged();
}

void Downloader::cancel() {
    m_cancel = true;
}

int Downloader::count() {
    return m_downloadlist.count();
}

void Downloader::downloadNext() {
    if (m_downloadlist.count() <= 0) {
        return;
    }
    DownloadPair p = m_downloadlist.dequeue();

    QDir d = QFileInfo(p.local.toLocalFile()).absoluteDir();

    QDir dir(d.absolutePath());
    if (!dir.exists()){
        dir.mkpath(".");
    }

    output.setFileName(p.local.toLocalFile());

    if (!output.open(QIODevice::WriteOnly)) {
        qDebug() << "Cannot save " << p.local;
        downloadNext();
        return;
    }

    QNetworkRequest request(p.url);
    request.setRawHeader("User-Agent", m_userAgent.toLatin1() );

    currentDownload = manager.get(request);
    connect(currentDownload, SIGNAL(finished()),
            SLOT(downloadFinished()));
    connect(currentDownload, SIGNAL(readyRead()),
            SLOT(downloadReadyRead()));


}

void Downloader::downloadFinished() {
    output.close();

    if (currentDownload->error()) {
        // download failed
        qDebug() << currentDownload->errorString();
        m_errorString = currentDownload->errorString();
        emit errorStringChanged();
        emit downloadNext();
        return;
    }

    if (m_cancel) {
        m_downloadlist.clear();
        m_cancel = false;
    }

    emit countChanged();
    currentDownload->deleteLater();
    emit downloadNext();
}

void Downloader::downloadReadyRead() {
    output.write(currentDownload->readAll());
}
