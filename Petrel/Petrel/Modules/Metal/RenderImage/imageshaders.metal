//
//  imageshaders.metal
//  Petrel
//
//  Created by wangwenjie on 2020/5/3.
//  Copyright © 2020 Petrel. All rights reserved.
//

#include <metal_stdlib>
#import "ImageShaderTypes.h"

using namespace metal;



typedef struct
{
    float4 clipSpacePosition [[position]];
    float2 textureCoordinate;
} RasterizerData;

vertex RasterizerData
imageVertexShader(uint vertexID [[ vertex_id ]],
                  constant ImageVertex *vertexArray [[buffer(0)]])
{
    RasterizerData out;
    out.clipSpacePosition = vertexArray[vertexID].position;
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
    return out;
}

fragment float4
imageSamplingShader(RasterizerData input [[stage_in]],
                    texture2d<half> colorTexture [[texture(0)]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    half4 colorSample = colorTexture.sample(textureSampler, input.textureCoordinate);
    return float4(colorSample);
}
