#include <Qt3DExtras/QForwardRenderer>
#include <Qt3DQuickExtras/qt3dquickwindow.h>
#include <QGuiApplication>
#include "photographer.h"
int main(int argc, char* argv[])
{
    qmlRegisterType<Photographer>("Photographer",1,0,"Photographer");
    QGuiApplication app(argc, argv);
    Qt3DExtras::Quick::Qt3DQuickWindow view;

    view.setWidth(200);
    view.setHeight(200);
    view.setSource(QUrl("qrc:/main.qml"));
    view.show();

    return app.exec();
}
