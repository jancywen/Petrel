//
//  ImageRenderer.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/3.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import MetalKit

class ImageRenderer: NSObject, MTKViewDelegate {
    
    var mtkView: MTKView
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    var texture: MTLTexture!
    var vertices: MTLBuffer!
    var numVertices: Int!
    var viewportSize: vector_uint2!
    
    init(mtkview: MTKView) {
        self.mtkView = mtkview
        super.init()

        self.setupPipeline()
        self.setupVertex()
//        self.setupTexture()
        self.configTexture()
    }
    
    
    func setupPipeline() {
        let defaultLibrary = mtkView.device?.makeDefaultLibrary()
        let vertexFunction = defaultLibrary?.makeFunction(name: "imageVertexShader")
        let fragmentFunction = defaultLibrary?.makeFunction(name: "imageSamplingShader")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        do {
            try pipelineState = mtkView.device?.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }catch {
            print(error)
        }
        
        commandQueue = mtkView.device?.makeCommandQueue()
    }

    func setupVertex() {
        let qvertex = [ImageVertex(position: vector_float4([-1.0, -1.0, 0.0, 1.0]), textureCoordinate: vector_float2([0.0, 1.0])),
                       ImageVertex(position: vector_float4([-1.0, 1.0, 0.0, 1.0]), textureCoordinate: vector_float2([0.0, 0.0])),
                       ImageVertex(position: vector_float4([1.0, -1.0, 0.0, 1.0]), textureCoordinate: vector_float2([1.0, 1.0])),
                       ImageVertex(position: vector_float4([1.0, 1.0, 0.0, 1.0]), textureCoordinate: vector_float2([1.0, 0.0])),
                       ]
        
        self.vertices = mtkView.device?.makeBuffer(bytes: qvertex, length: qvertex.count * MemoryLayout<ImageVertex>.size, options: .storageModeShared)
        self.numVertices = qvertex.count
    }
    
    func setupTexture() {
        let url = Bundle.main.url(forResource: "Image", withExtension: "tga")
        
        guard let image = AAPLImage(tgaFileAtLocation: url!) else {
            return
        }
        
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.width = Int(image.width)
        textureDescriptor.height = Int(image.height)
        textureDescriptor.pixelFormat = .bgra8Unorm
        textureDescriptor.usage = .shaderRead
        textureDescriptor.textureType = .type2D
        
        self.texture = mtkView.device?.makeTexture(descriptor: textureDescriptor)
        
        let region = MTLRegionMake2D(0, 0, textureDescriptor.width, textureDescriptor.height)
        image.data.withUnsafeBytes({ (bytes: UnsafePointer<UInt8>) in
            let raw = UnsafeRawPointer(bytes)
            self.texture.replace(region: region, mipmapLevel: 0, withBytes: raw, bytesPerRow: 4 * textureDescriptor.width)
        })
        
    }
    func configTexture() {
        guard let image = UIImage(named: "girl") else {
            return
        }
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.width = Int(image.size.width)
        textureDescriptor.height = Int(image.size.height)
        textureDescriptor.pixelFormat = .rgba8Unorm
        textureDescriptor.usage = .shaderRead
        textureDescriptor.textureType = .type2D
        
        self.texture = mtkView.device?.makeTexture(descriptor: textureDescriptor)
        
        let region = MTLRegionMake2D(0, 0, textureDescriptor.width, textureDescriptor.height)
        guard let raw = image.load() else {
            return
        }
        self.texture.replace(region: region, mipmapLevel: 0, withBytes: raw, bytesPerRow: 4 * textureDescriptor.width)
    }
    
    //MARK: MTKViewDelegate
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewportSize = vector_uint2(UInt32(size.width), UInt32(size.height))
    }
    
    func draw(in view: MTKView) {
        // 每次渲染都要单独创建一个 CommandBuffer
        let commandBuffer = commandQueue.makeCommandBuffer()
        // 过程描述符
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        // 设置默认颜色
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.5, 0.5, 1.0)
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        // 设置显示区域
        renderEncoder?.setViewport(MTLViewport(originX: 0, originY: 0, width: Double(viewportSize.x), height: Double(viewportSize.y), znear: -1.0, zfar: 1.0))
        // 设置管道
        renderEncoder?.setRenderPipelineState(pipelineState)
        // 设置顶点缓存
        renderEncoder?.setVertexBuffer(vertices, offset: 0, index: 0)
        // 设置纹理
        renderEncoder?.setFragmentTexture(self.texture, index: 0)
        // 绘制
        renderEncoder?.drawPrimitives(type: MTLPrimitiveType.triangleStrip, vertexStart: 0, vertexCount: self.numVertices)
        // 结束
        renderEncoder?.endEncoding()
        // 显示
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer?.present(drawable)
        // 提交
        commandBuffer?.commit()
        
    }
}
