#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
layout(location = 0) uniform vec3 inputFirstColor;
layout(location = 1) uniform vec3 inputSecondColor;
layout(location = 2) uniform vec2 screenSize;

const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

vec4 processColor(vec4 sourceColor) {
    float luminance = dot(sourceColor.rgb, luminanceWeighting);

    return vec4(mix(inputFirstColor.rgb, inputSecondColor.rgb, luminance), sourceColor.a);
}

void main() {
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor);
}