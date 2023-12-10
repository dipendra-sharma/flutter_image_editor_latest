#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
layout(location = 0) uniform highp float inputExposure;
layout(location = 1) uniform vec2 screenSize;

vec4 processColor(vec4 sourceColor) {
    return vec4(sourceColor.rgb * pow(2.0, inputExposure), sourceColor.w);
}

void main() {
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    highp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor);
}