//
//  TriangleRenderTypes.h
//  Petrel
//
//  Created by wangwenjie on 2020/5/2.
//  Copyright © 2020 Petrel. All rights reserved.
//

#ifndef TriangleRenderTypes_h
#define TriangleRenderTypes_h

#include <simd/simd.h>

// Buffer index values shared between shader and C code to ensure Metal shader buffer inputs
// match Metal API buffer set calls.
typedef enum TriangleVertexInputIndex
{
    TriangleVertexInputIndexVertices     = 0,
    TriangleVertexInputIndexViewportSize = 1,
} TriangleVertexInputIndex;

//  This structure defines the layout of vertices sent to the vertex
//  shader. This header is shared between the .metal shader and C code, to guarantee that
//  the layout of the vertex array in the C code matches the layout that the .metal
//  vertex shader expects.
typedef struct
{
    vector_float2 position;
    vector_float4 color;
} TriangleVertex;
#endif /* TriangleRenderTypes_h */


