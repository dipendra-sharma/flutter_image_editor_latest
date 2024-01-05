#include <flutter/runtime_effect.glsl>

precision mediump float;

layout(location = 0) uniform float sharpness;
layout(location = 1) uniform vec2 screenSize;
layout(location = 2) uniform sampler2D inputImageTexture;

layout(location = 0) out vec4 fragColor;

void main() {
    vec2 texSize = screenSize;
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 texCoord = fragCoord / texSize;

    float neighbor = sharpness * -1.0;
    float center = sharpness * 4.0 + 1.0;

    vec3 color =
    texture(inputImageTexture, (fragCoord + vec2( 0,  1)) / texSize).rgb * neighbor
    + texture(inputImageTexture, (fragCoord + vec2(-1,  0)) / texSize).rgb * neighbor
    + texture(inputImageTexture, (fragCoord + vec2( 0,  0)) / texSize).rgb * center
    + texture(inputImageTexture, (fragCoord + vec2( 1,  0)) / texSize).rgb * neighbor
    + texture(inputImageTexture, (fragCoord + vec2( 0, -1)) / texSize).rgb * neighbor;

    fragColor = vec4(color, texture(inputImageTexture, texCoord).a);
}
