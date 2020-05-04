//
//  transformshaders.metal
//  Petrel
//
//  Created by wangwenjie on 2020/5/3.
//  Copyright © 2020 Petrel. All rights reserved.
//

#include <metal_stdlib>
#include "TransformShaderTypes.h"

using namespace metal;


typedef struct
{
    float4 clipSpacePosition [[position]];
    float3 pixelColor;
    float2 textureCoordinate;
    
} RasterizerData;

vertex RasterizerData // 顶点
transVertexShader(uint vertexID [[ vertex_id ]],
             constant TransformVertex *vertexArray [[ buffer(VertexInputIndexVertices) ]],
             constant TransformMatrix *matrix [[ buffer(VertexInputIndexMatrix) ]]) {
    RasterizerData out;
    out.clipSpacePosition = matrix->transProjectionMatrix * matrix->transModelViewMatrix * vertexArray[vertexID].position;
//    out.clipSpacePosition = vertexArray[vertexID].position;
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
    out.pixelColor = vertexArray[vertexID].color;
    
    return out;
}

fragment float4 // 片元
transSamplingShader(RasterizerData input [[stage_in]],
               texture2d<half> textureColor [[ texture(FragmentInputIndexTexture) ]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    
    half4 colorTex = textureColor.sample(textureSampler, input.textureCoordinate);
//    half4 colorTex = half4(input.pixelColor.x, input.pixelColor.y, input.pixelColor.z, 1);
    return float4(colorTex);
}
