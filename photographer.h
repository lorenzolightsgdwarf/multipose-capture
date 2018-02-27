#ifndef PHOTOGRAPHER_H
#define PHOTOGRAPHER_H

#include <QObject>
#include <Qt3DRender/QRenderCapture>
#include <Qt3DCore/QNode>
#include <QFile>

class Photographer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Qt3DRender::QRenderCapture* render_capture READ render_capture NOTIFY render_captureChanged)
public:
    explicit Photographer(QObject *parent = 0);
    ~Photographer();
signals:
    void captureDone();
    void render_captureChanged();
public slots:
    void attachCapture(Qt3DCore::QNode* activeframegraph);
    void capture(QVariant quad);
    void close();
    Qt3DRender::QRenderCapture*  render_capture(){return m_render_capture;}
private slots:
    void onCompleted();
private:
    Qt3DRender::QRenderCapture* m_render_capture;
    Qt3DRender::QRenderCaptureReply *m_reply=Q_NULLPTR;
    long id=1;
    QVariant last_quad;
    QFile m_quad_file;
    QTextStream m_textstream;
};

#endif // PHOTOGRAPHER_H
