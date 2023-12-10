#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
layout(location = 0) uniform highp float inputColorLevels;
layout(location = 1) uniform vec2 screenSize;

vec4 processColor(vec4 sourceColor) {
    return floor((sourceColor * inputColorLevels) + vec4(0.5)) / inputColorLevels;
}

void main() {
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    highp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor);
}