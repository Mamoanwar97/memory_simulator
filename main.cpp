#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "Memory.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

//    qmlRegisterType<hole>("Hole",1,0,"Hole");


    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    memory* Memory = new memory();
    engine.rootContext()->setContextProperty("MemoryBackend",Memory);



    return app.exec();
}
