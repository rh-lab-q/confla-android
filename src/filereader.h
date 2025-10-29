#ifndef FILEREADER_H
#define FILEREADER_H

#include <QObject>

class FileReader : public QObject
{
    Q_OBJECT
public:
    explicit FileReader(QObject *parent = 0);

    Q_INVOKABLE QByteArray read_local(const QString &filename);
    Q_INVOKABLE bool file_exists_local(const QString &filename);
    Q_INVOKABLE void write_local(const QString &filename, QByteArray data);


    Q_INVOKABLE void write(const QUrl &filename, QByteArray data);
    Q_INVOKABLE bool file_exists(const QUrl &filename);
    Q_INVOKABLE QByteArray read(const QUrl &filename);

    Q_INVOKABLE bool is_local_file(const QUrl &filename);

    Q_INVOKABLE QString getBasename(const QString fullname);


signals:

public slots:

};

#endif // FILEREADER_H
