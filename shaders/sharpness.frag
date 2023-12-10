#include <flutter/runtime_effect.glsl>

precision mediump float;

layout(location = 0) uniform float inputSharpness;
layout(location = 1) uniform vec2 screenSize;
layout(location = 2) uniform sampler2D inputImageTexture;

layout(location = 0) out vec4 fragColor;

vec4 sharpen1(vec2 texCoords, vec2 resolution, float sharpness) {
    // Define the offsets in texel units
    vec2 texelSize = 1.0 / resolution;
    vec2 offset[5];
    offset[0] = texCoords;
    offset[1] = texCoords + texelSize * vec2(0.0, -1.0);
    offset[2] = texCoords + texelSize * vec2(0.0, 1.0);
    offset[3] = texCoords + texelSize * vec2(-1.0, 0.0);
    offset[4] = texCoords + texelSize * vec2(1.0, 0.0);

    // Sample the texture at the center and surrounding points
    vec4 centerTexel = texture(inputImageTexture, offset[0]);
    vec4 texelUp = texture(inputImageTexture, offset[1]);
    vec4 texelDown = texture(inputImageTexture, offset[2]);
    vec4 texelLeft = texture(inputImageTexture, offset[3]);
    vec4 texelRight = texture(inputImageTexture, offset[4]);

    // Apply the sharpening kernel
    vec4 result = centerTexel * (1.0 + 4.0 * sharpness) - sharpness * (texelUp + texelDown + texelLeft + texelRight);

    // Combine the original color with the sharpened color based on the sharpness factor
    result = mix(centerTexel, result, sharpness);

    // Clamp the result to avoid overflow/underflow
    result = clamp(result, 0.0, 1.0);

    return result;
}

vec4 sharpen2(vec2 texCoords, vec2 resolution, float sharpness) {
    vec2 texelSize = 1.0 / resolution;
    vec2 offsets[9] = vec2[](vec2(-texelSize.x, texelSize.y), // top-left
    vec2(0.0, texelSize.y),          // top-center
    vec2(texelSize.x, texelSize.y),  // top-right
    vec2(-texelSize.x, 0.0),         // center-left
    vec2(0.0, 0.0),                  // center
    vec2(texelSize.x, 0.0),          // center-right
    vec2(-texelSize.x, -texelSize.y),// bottom-left
    vec2(0.0, -texelSize.y),         // bottom-center
    vec2(texelSize.x, -texelSize.y)  // bottom-right
    );

    float kernel[9] = float[](-1, -1, -1, -1, 9, -1, -1, -1, -1);

    vec4 sampleTex[9];
    for(int i = 0; i < 9; i++) {
        sampleTex[i] = texture(inputImageTexture, texCoords + offsets[i]);
    }

    vec4 sum = vec4(0.0);
    for(int i = 0; i < 9; i++) {
        sum += sampleTex[i] * kernel[i];
    }

    sum = mix(texture(inputImageTexture, texCoords), sum, sharpness);
    return clamp(sum, 0.0, 1.0);
}

void main() {
    vec2 texCoords = FlutterFragCoord().xy / screenSize;
    fragColor = sharpen2(texCoords, screenSize, inputSharpness);
}
