//
//  TriangleRenderer.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/2.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import MetalKit
import simd

class TriangleRenderer: NSObject {
    
    var _device: MTLDevice?
    var _pipelineState: MTLRenderPipelineState!
    var _commandQueue: MTLCommandQueue?
    var _viewportSize: vector_uint2!
    
    init(mtkview: MTKView) {
        _device = mtkview.device
        let defaultLibrary = _device?.makeDefaultLibrary()
        let vertexFunction = defaultLibrary?.makeFunction(name: "triangleVertexShader")
        let fragmentFunction = defaultLibrary?.makeFunction(name: "triangleFragmentShader")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Simple Pipeline"
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.fragmentFunction = fragmentFunction
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkview.colorPixelFormat
        guard let state = try? _device?.makeRenderPipelineState(descriptor: pipelineStateDescriptor) else {
            return
        }
        _pipelineState = state
        _commandQueue = _device?.makeCommandQueue()
        _viewportSize = vector_uint2(0, 0)

    }
}

extension TriangleRenderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
//        _viewportSize = vector_double2(x: Double(size.width), y: Double(size.height))
        _viewportSize.x = UInt32(size.width)
        _viewportSize.y = UInt32(size.height)
    }
    
    func draw(in view: MTKView) {
        
        let triangleVertices: [TriangleVertex] =
        [
            TriangleVertex(position: vector_float2(x:250, y:-250), color: vector_float4([1, 0, 0, 1])),
            TriangleVertex(position: vector_float2([-250, -250]), color: vector_float4([0, 1, 0, 1])),
            TriangleVertex(position: vector_float2( [0, -250]), color: vector_float4([0, 0, 1, 1]))
        ]

        
        let commandBuffer = _commandQueue?.makeCommandBuffer()
        commandBuffer?.label = "MyCommand"
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.label = "MyRenderEncoder"
        renderEncoder?.setViewport(MTLViewport(originX: 0.0, originY: 0.0, width: Double(_viewportSize!.x), height: Double(_viewportSize!.y), znear: 0.0, zfar: 1.0))
        renderEncoder?.setRenderPipelineState(_pipelineState)
        
        renderEncoder?.setVertexBytes(triangleVertices,
                                      length: triangleVertices.count * MemoryLayout<TriangleVertex>.size,
                                      index: Int(TriangleVertexInputIndexVertices.rawValue))

        renderEncoder?.setVertexBytes(&_viewportSize,
                                      length: MemoryLayout<vector_uint2>.size,
                                      index: Int(TriangleVertexInputIndexViewportSize.rawValue))
        
        renderEncoder?.drawPrimitives(type: MTLPrimitiveType.triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder?.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer?.present(drawable)
        
        commandBuffer?.commit()
        
    }
    
    
}
