//
//  panoramashaders.metal
//  Petrel
//
//  Created by wangwenjie on 2020/5/4.
//  Copyright © 2020 Petrel. All rights reserved.
//

#include <metal_stdlib>
#include "PanoramaShaderTypes.h"

using namespace metal;

typedef struct
{
    float4 clipSpacePosition [[position]];
    float3 pixelColor;
    float2 textureCoordinate;
} RasterizerData;

vertex RasterizerData // 顶点
panorVertexShader(uint vertexID [[ vertex_id ]],
             constant PanoramaVertex *vertexArray [[ buffer(PanorVertexInputIndexVertices) ]],
             constant PanoramaMatrix *matrix [[ buffer(PanorVertexInputIndexMatrix) ]]) {
    RasterizerData out;
    out.clipSpacePosition = matrix->panoramaProjectionMatrix * matrix->panoramaModelViewMatrix * vertexArray[vertexID].position;
//    out.clipSpacePosition = vertexArray[vertexID].position;
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
    out.pixelColor = vertexArray[vertexID].color;
    
    return out;
}

fragment float4 // 片元
panorSamplingShader(RasterizerData input [[stage_in]],
               texture2d<half> textureColor [[ texture(PanorFragmentInputIndexTexture) ]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    
    half4 colorTex = textureColor.sample(textureSampler, input.textureCoordinate);
//    half4 colorTex = half4(input.pixelColor.x, input.pixelColor.y, input.pixelColor.z, 1);
    return float4(colorTex);
}
