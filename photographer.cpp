#include "photographer.h"
#include <QQuaternion>
Photographer::Photographer(QObject *parent) : QObject(parent)
{
    m_quad_file.setFileName("images/quad.txt");
    auto opened=m_quad_file.open(QIODevice::WriteOnly | QIODevice::Text);
    m_textstream.setDevice(&m_quad_file);
}

Photographer::~Photographer()
{
    m_textstream.flush();
    m_quad_file.close();
}
void Photographer::attachCapture(Qt3DCore::QNode *activeframegraph)
{
    m_render_capture=new Qt3DRender::QRenderCapture();
    activeframegraph->setParent(m_render_capture);
    emit render_captureChanged();
}

void Photographer::onCompleted()
{
    QObject::disconnect(m_reply);
    m_reply->saveImage(QString("images/capture")+QString::number(id)+QString(".png"));
    QQuaternion q=last_quad.value<QQuaternion>();
    m_textstream<<id<<","<<q.scalar()<<","<<q.x()<<","<<q.y()<<","<<q.z()<<"\n";
    id++;
    delete m_reply;
    m_reply = nullptr;
    emit captureDone();
}

void Photographer::capture(QVariant quad)
{
    if (!m_reply) {
        m_reply = m_render_capture->requestCapture();
        QObject::connect(m_reply, &Qt3DRender::QRenderCaptureReply::completed,
                                      this, &Photographer::onCompleted);
        last_quad=quad;
    }
}

void Photographer::close()
{
    m_textstream.flush();
    m_quad_file.close();
}
