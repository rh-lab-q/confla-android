# confla-android
Mobile client for conflab

It aims to be easy adoptable as single conference application. 

By default it is using https://github.com/rh-lab-q/conflab project


# Build notes

## Android NDK

When using Qt from Qt Installer (i.e. not compiling it yourself), use NDK r10e. Anything else will give you
a hard time because Qt itself is built against this version.

Also newer NDKs have completely replaced GCC with clang and libc++ - mixing libstdc++ Qt and libc++-built binary
does not really work. Neither does OpenSSL unless you use OpenSSL 1.1.1, which pre-compiler Qt does not support.

## Building OpenSSL for Qt

* Download this script https://wiki.openssl.org/images/7/70/Setenv-android.sh
* Modify the script:
  * `_ANDROID_NDK="android-ndk-r10e"`
  * `_ANDROID_EABI="arm-linux-androidebabi-4.9"`
  * `_ANDROID_ARCH="arch-arm"`
  * `_ANDROID_API="android-18"`
  * if you get an error on line 201, replace the `==` with a single `=`
* Download latest OpenSSL 1.0 (OpenSSL 1.1 will not work with precompiled Qt, may work if you build Qt yourself)
* Build OpenSSL for Android ARM:
    ```
    cd openssl-1.0.2p
    export ANDROID_NDK_ROOT=/opt/android/android-ndk-r10e
    . ../Setenv-android.sh
    ./Configure shared android
    make CALC_VERSIONS="SHLIB_COMPAT=; SHLIB_SOVER=" build_libs
    mkdir -p /path/to/android-confla/android/libs/armeabi-v7a
    mv libcrypto.so libssl.so /path/to/android-confla/android/libs/armeabi-v7a/
    make distclean
    ```
* Modify the script again:
  * `_ANDROID_NDK="android-ndk-r10e"`
  * `_ANDROID_EABI="x86-4.9"`
  * `_ANDROID_ARCH="arch-x86"`
  * `_ANDROID_API="android-18"`
* Build OpenSSL for Android x64
    ```
    cd openssl-1.0.2p
    export ANDROID_NDK_ROOT=/opt/android/android-ndk-r10e
    . ../Setenv-android.sh
    ./Configure shared android-x86
    make CALC_VERSIONS="SHLIB_COMPAT=; SHLIB_SOVER=" build_libs
    mkdir -p /path/to/android-confla/android/libs/x86
    mv libcrypto.so libssl.so /path/to/android-confla/android/libs/x86/
    ```

That's all, qmake should pick up the libraries automatically if they exist in android/libs/[arch]
