//
//  TransformShaderTypes.h
//  Petrel
//
//  Created by wangwenjie on 2020/5/3.
//  Copyright © 2020 Petrel. All rights reserved.
//

#ifndef TransformShaderTypes_h
#define TransformShaderTypes_h

#include <simd/simd.h>

typedef struct
{
    vector_float4 position;
    vector_float3 color;
    vector_float2 textureCoordinate;
} TransformVertex;


typedef struct
{
    matrix_float4x4 transProjectionMatrix;
    matrix_float4x4 transModelViewMatrix;
} TransformMatrix;

typedef enum TransformVertexInputIndex
{
    VertexInputIndexVertices = 0,
    VertexInputIndexMatrix = 1
} TransformVertexInputIndex;

typedef enum TransformFragmentInputIndex
{
    FragmentInputIndexTexture = 0
} TransformFragmentInputIndex;

#endif /* TransformShaderTypes_h */
