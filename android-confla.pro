TEMPLATE = app

QT += qml quick widgets
CONFIG += c++11


SOURCES += main.cpp \
    filereader.cpp \
    downloader.cpp \
    customnetworkaccessmanager.cpp \
    networkaccessmanagerfactory.cpp

RESOURCES += qml.qrc Maps.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    filereader.h \
    downloader.h \
    customnetworkaccessmanager.h \
    networkaccessmanagerfactory.h

QT += sql


ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    exists($$PWD/android/libs/armeabi-v7a/libssl.so) {
        ANDROID_EXTRA_LIBS = \
            $$PWD/android/libs/armeabi-v7a/libcrypto.so \
            $$PWD/android/libs/armeabi-v7a/libssl.so
    }
}

contains(ANDROID_TARGET_ARCH,x86) {
    exists($$PWD/android/libs/x86/libssl.so) {
        ANDROID_EXTRA_LIBS = \
            $$PWD/android/libs/x86/libcrypto.so \
            $$PWD/android/libs/x86/libssl.so
    }
}


