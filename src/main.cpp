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


    // QString tr_path(TRANSLATION_FOLDER);
    QString tr_path("/home/jmlich/workspace/confla-android/build");
    if ( !tr_path.isEmpty() ) {
        QString locale = QLocale::system().name();
        QTranslator *translator = new QTranslator();

        if ( !translator->load(QLocale(), "harbour-confla", "-", tr_path) ) {
            if ( !translator->load("en_US", "harbour-confla", "-", tr_path) ) {
                qWarning() << "Cannot load translations for " << locale << " " << tr_path;
            }
        }

        app.installTranslator(translator);
    }

    NetworkAccessManagerFactory namFactory;

    qmlRegisterType<FileReader>("cz.mlich", 1, 0, "FileReader");
    qmlRegisterType<Downloader>("cz.mlich", 1, 0, "Downloader");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("IMAGE_CACHE_FOLDER", "file://" +QStandardPaths::writableLocation(QStandardPaths::DataLocation) );
    engine.setNetworkAccessManagerFactory(&namFactory);

    engine.rootContext()->setContextProperty("dpix", app.desktop()->logicalDpiX());
    engine.rootContext()->setContextProperty("dpiy", app.desktop()->logicalDpiY());
    engine.load(QUrl("qrc:/qml/main.qml"));

    return app.exec();
}
