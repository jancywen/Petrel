//
//  PanoramaShaderTypes.h
//  Petrel
//
//  Created by wangwenjie on 2020/5/4.
//  Copyright © 2020 Petrel. All rights reserved.
//

#ifndef PanoramaShaderTypes_h
#define PanoramaShaderTypes_h


#include <simd/simd.h>

typedef struct {
    vector_float4 position;
    vector_float3 color;
    vector_float2 textureCoordinate;
} PanoramaVertex;


typedef struct
{
    matrix_float4x4 panoramaProjectionMatrix;
    matrix_float4x4 panoramaModelViewMatrix;
} PanoramaMatrix;

typedef enum PanoramaVertexInputIndex
{
    PanorVertexInputIndexVertices = 0,
    PanorVertexInputIndexMatrix = 1
} PanoramaVertexInputIndex;

typedef enum PanoramaFragmentInputIndex
{
    PanorFragmentInputIndexTexture = 0
} PanoramaFragmentInputIndex;

#endif /* PanoramaShaderTypes_h */
