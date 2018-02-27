import QtQuick 2.2 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import Photographer 1.0
Entity {
    id: sceneRoot


    QQ2.Timer{
        interval: 1000
        onTriggered: {
          photographer.capture(transform.rotation)
        }
        running: true

    }


    ForwardRenderer {
        id:forward_render
        objectName: "forwardRenderer"
        clearColor: "black"
        camera:     Camera {
            projectionType: CameraLens.PerspectiveProjection
            fieldOfView: 45
            aspectRatio: 16/9
            nearPlane : 0.1
            farPlane : 1000.0
            position: Qt.vector3d(0,0,0)
            upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
            viewCenter: Qt.vector3d( 0.0, 0.0, -1 )
        }
    }
    Photographer{
        property real step_angle:5
        property real step_radius:5
        property real r: 20
        property real yaw: -89 //-90--90
        property real pitch: -89 //0--90
        property real roll: -89 //0--90

        id:photographer
        QQ2.Component.onCompleted: {
            attachCapture(forward_render)
            transform.rotation=transform.fromEulerAngles(pitch,yaw,roll);
        }
        onCaptureDone: {
            yaw=yaw+step_angle
            if(yaw>89){
                pitch=pitch+step_angle
                yaw=-89
            }
            if(pitch>89){
                pitch=-89
                roll=roll+step_angle
            }
            if(roll>89){
                roll=-89
                r=r+step_radius
            }
            if(r<21){
                transform.rotation=transform.fromEulerAngles(pitch,yaw,roll);
                capture(transform.rotation)
            }else
                close()
        }
    }
    components: [
        RenderSettings {
            id:settings
            activeFrameGraph:photographer.render_capture
        }
    ]


    PhongMaterial {
        id: material
    }

    Mesh {
        id: mesh
        source:"qrc:/struct1.obj"
    }
    Transform{
        id:transform
        translation:Qt.vector3d(0,0,-20)
        onRotationChanged:console.log(rotation)

    }
    Entity {
        id: entity
        components: [ mesh, simplemat ,transform]
    }
    Material{
        id:simplemat
        effect: Effect{
            techniques:[
                Technique{
                    graphicsApiFilter {
                        api: GraphicsApiFilter.OpenGL
                        profile: GraphicsApiFilter.CoreProfile
                        majorVersion: 3
                        minorVersion: 1
                    }
                    filterKeys: [ FilterKey { name : "renderingStyle"; value : "forward" } ]
                    renderPasses: [RenderPass {
                        shaderProgram: ShaderProgram {
                            vertexShaderCode:   "

#version 150 core

in vec3 vertexPosition;
in vec3 vertexNormal;
in vec4 vertexTangent;
in vec2 vertexTexCoord;

out vec3 worldPosition;
out vec3 worldNormal;
out vec4 worldTangent;
out vec2 texCoord;

uniform mat4 modelMatrix;
uniform mat3 modelNormalMatrix;
uniform mat4 modelViewProjection;

uniform float texCoordScale;

void main()
{
    // Pass through scaled texture coordinates
    texCoord = vertexTexCoord * texCoordScale;

    // Transform position, normal, and tangent to world space
    worldPosition = vec3(modelMatrix * vec4(vertexPosition, 1.0));
    worldNormal = normalize(modelNormalMatrix * vertexNormal);
    worldTangent.xyz = normalize(vec3(modelMatrix * vec4(vertexTangent.xyz, 0.0)));
    worldTangent.w = vertexTangent.w;

    // Calculate vertex position in clip coordinates
    gl_Position = modelViewProjection * vec4(vertexPosition, 1.0);
}"
                            fragmentShaderCode: "

                                             #version 150 core

                                             out vec4 fragColor;

                                             void main()
                                             {
                                                 //output color from material
                                                 fragColor = vec4(1.0,1.0,1.0,1.0);
                                             }
                                             "
                        }
                    }]

                    // no special render state set => use the default set of states
                }]



        }


    }



}
