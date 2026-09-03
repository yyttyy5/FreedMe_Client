#include <QCoreApplication>
#include <QWebSocket>
#include <QObject>
#include <QThread>

// Класс для чтения из консоли в отдельном потоке
class ConsoleReader : public QObject
{
    Q_OBJECT
public:
    explicit ConsoleReader(QObject *parent = nullptr) : QObject(parent) {}

public slots:
    void readLoop()
    {
        QTextStream stream(stdin);
        QString line;
        while (true) {
            line = stream.readLine();
            if (!line.isNull()) {
                emit lineRead(line);
            }
        }
    }

    signals:
        void lineRead(const QString &line);
};

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    QWebSocket socket;

    QObject::connect(&socket,
        &QWebSocket::connected,
        [&socket]() {
        qDebug().noquote() << QString("Successfully connected to: %1:%2")
           .arg(socket.peerAddress().toString())
           .arg(socket.peerPort());
    });

    QObject::connect(&socket,
        &QWebSocket::textMessageReceived,
        [](const QString &message) {
        qDebug().noquote() << "Message from server:" << message;
    });

    // Запускаем поток для чтения из консоли
    QThread readerThread;
    ConsoleReader reader;
    reader.moveToThread(&readerThread);

    // При запуске потока начинаем читать
    QObject::connect(&readerThread,
        &QThread::started,
        &reader,
        &ConsoleReader::readLoop);

    // Полученную строку отправляем на сервер
    QObject::connect(&reader,
        &ConsoleReader::lineRead,
        [&socket](const QString &line) {
                QMetaObject::invokeMethod(&socket, [&socket, line]()
                {
                    if (line == "exit" || line == "quit") {
                        qDebug().noquote() << "Exiting...";
                        QCoreApplication::quit();
                        return;
                    }

                    if (socket.state() == QAbstractSocket::ConnectedState) {
                        socket.sendTextMessage(line);
                        qDebug().noquote() << "Sent:" << line;
                    } else {
                        qDebug().noquote() << "Not connected!";
                    }
                }, Qt::QueuedConnection);
        });

    readerThread.start();

    socket.open(QUrl("ws://127.0.0.1:9000"));

    qDebug().noquote() << "Type messages and press Enter. Type 'exit' to quit.";

    int result = app.exec();

    // Корректное завершение
    readerThread.quit();
    readerThread.wait();

    return result;
}

#include "main.moc"