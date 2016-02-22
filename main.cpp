#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QDesktopWidget>
#include "filereader.h"
#include "networkaccessmanagerfactory.h"
#include "downloader.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    NetworkAccessManagerFactory namFactory;


    qmlRegisterType<FileReader>("cz.mlich", 1, 0, "FileReader");
    qmlRegisterType<Downloader>("cz.mlich", 1, 0, "Downloader");

    QTranslator translator;

    if (translator.load(QLatin1String(":/android-confla-") + QLocale::system().name() + QLatin1String(".qm"))) {
        app.installTranslator(&translator);
    } else {
        if (translator.load(QLatin1String(":/android-confla-en_US.qm"))) {
            app.installTranslator(&translator);
        }
    }

//    if (translator.load(QLatin1String(":/android-confla-cs_CZ.qm"))) {
//        app.installTranslator(&translator);
//    }

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("IMAGE_CACHE_FOLDER", "file://" +QStandardPaths::writableLocation(QStandardPaths::DataLocation) );
    engine.setNetworkAccessManagerFactory(&namFactory);

    engine.rootContext()->setContextProperty("dpix", app.desktop()->logicalDpiX());
    engine.rootContext()->setContextProperty("dpiy", app.desktop()->logicalDpiY());
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
