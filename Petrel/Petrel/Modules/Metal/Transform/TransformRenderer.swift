//
//  TransformRenderer.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/3.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation
import GLKit

class TransformRender: NSObject, MTKViewDelegate {
    
    var mtkView: MTKView
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var texture: MTLTexture!
    var vertices: MTLBuffer!
    var indexs: MTLBuffer!
    var indexCount: Int!
    
    var viewportSize: vector_uint2!
    
    var x: Float = 0.0, y: Float = 0.0, z: Float = 0.0

    var isX: Bool = false
    var isY: Bool = false
    var isZ: Bool = false
    var sildeValue: Float = 0.02
    
    init(mtkView: MTKView) {
        self.mtkView = mtkView
        super.init()
        
        self.setupPipeline()
        self.setupVertex()
        self.setupTexture()
    }
    
    
    func setupPipeline() {
        let defaultLibrary = mtkView.device?.makeDefaultLibrary()
        let vertexFunction = defaultLibrary?.makeFunction(name: "transVertexShader")
        let fragmentFunction = defaultLibrary?.makeFunction(name: "transSamplingShader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat
        
        do {
            try self.pipelineState = self.mtkView.device?.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }catch {
            print(error)
        }
        self.commandQueue = self.mtkView.device?.makeCommandQueue()
    }
    
    func setupVertex() {
        let vertex = [TransformVertex(position: vector_float4([-0.5, 0.5, 0.0, 1.0]),
                                      color: vector_float3([0.0, 0.0, 0.5]),
                                      textureCoordinate: vector_float2([0.0, 0.0])), // 左上
                      TransformVertex(position: vector_float4([0.5, 0.5, 0.0, 1.0]),
                                      color: vector_float3([0.0, 0.5, 0.0]),
                                      textureCoordinate: vector_float2([1.0, 0.0])), // 右上
                      TransformVertex(position: vector_float4([-0.5, -0.5, 0.0, 1.0]),
                                      color: vector_float3([0.5, 0.0, 1.0]),
                                      textureCoordinate: vector_float2([0.0, 1.0])), // 左下
                      TransformVertex(position: vector_float4([0.5, -0.5, 0.0, 1.0]),
                                      color: vector_float3([0.0, 0.0, 0.5]),
                                      textureCoordinate: vector_float2([1.0, 1.0])), // 右下
                      TransformVertex(position: vector_float4([-0.0, 0.0, 1.0, 1.0]),
                                      color: vector_float3([1.0, 1.0, 1.0]),
                                      textureCoordinate: vector_float2([0.5, 0.5])), // 顶点
        ]
        
        self.vertices = mtkView.device?.makeBuffer(bytes: vertex, length: vertex.count * MemoryLayout<TransformVertex>.size, options: .storageModeShared)
        
        let indices:[UInt32] = [
            0, 3, 2,
            0, 1, 3,
            0, 2, 4,
            0, 4, 1,
            2, 3, 4,
            1, 4, 3,
        ]
        self.indexs = mtkView.device?.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt32>.size, options: .storageModeShared)
        self.indexCount = indices.count
    }
    
    func setupTexture() {
        guard let image = UIImage(named: "girl") else {
            return
        }
        
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = .rgba8Unorm
        textureDescriptor.width = Int(image.size.width)
        textureDescriptor.height = Int(image.size.height)
        
        self.texture = self.mtkView.device?.makeTexture(descriptor: textureDescriptor)
        let region = MTLRegionMake3D(0, 0, 0, Int(image.size.width), Int(image.size.height), 1)
        guard let raw = image.load() else {
            return
        }
        self.texture.replace(region: region, mipmapLevel: 0, withBytes: raw, bytesPerRow: 4 * textureDescriptor.width)
    }
    
    func getMetalMatrix(_ matrix: GLKMatrix4) -> matrix_float4x4 {
        let ret = matrix_float4x4(columns: (
            simd_make_float4(matrix.m00, matrix.m01, matrix.m02, matrix.m03),
            simd_make_float4(matrix.m10, matrix.m11, matrix.m12, matrix.m13),
            simd_make_float4(matrix.m20, matrix.m21, matrix.m22, matrix.m23),
            simd_make_float4(matrix.m30, matrix.m31, matrix.m32, matrix.m33)))
        return ret
    }
    
    func setupMatrixWithEncoder(_ encoder: MTLRenderCommandEncoder?) {
        let size = mtkView.bounds.size
        let aspect = abs(size.width / size.height)
        let projectMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0), Float(aspect), 0.1, 10.0)
        var modelMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, -2.0)
        if isX {
            x += sildeValue
        }
        if isY {
            y += sildeValue
        }
        if isZ {
            z += sildeValue
        }
        
        modelMatrix = GLKMatrix4Rotate(modelMatrix, y , 1, 0, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, x , 0, 1, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, Float(z), 0, 0, 1)
        
        var matrix = TransformMatrix(transProjectionMatrix: getMetalMatrix(projectMatrix),
                                     transModelViewMatrix: getMetalMatrix(modelMatrix))
        
        encoder?.setVertexBytes(&matrix,
                                length: MemoryLayout<TransformMatrix>.size,
                                index: Int(VertexInputIndexMatrix.rawValue))
                
    }
    
    // MARK: MTKViewDelegate
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewportSize = vector_uint2(UInt32(size.width), UInt32(size.height))
    }

    func draw(in view: MTKView) {
        let commandBuffer = self.commandQueue.makeCommandBuffer()
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.5, 0.5, 1.0)
        renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadAction.clear
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setViewport(MTLViewport(originX: 0, originY: 0, width: Double(viewportSize.x), height: Double(viewportSize.y), znear: -1.0, zfar: 1.0))
        
        renderEncoder?.setRenderPipelineState(pipelineState)
        //
        self.setupMatrixWithEncoder(renderEncoder)
        
        renderEncoder?.setVertexBuffer(self.vertices, offset: 0, index: Int(VertexInputIndexVertices.rawValue))
        renderEncoder?.setFrontFacing(MTLWinding.counterClockwise)
        renderEncoder?.setCullMode(.back)
        renderEncoder?.setFragmentTexture(self.texture, index: 0)
        renderEncoder?.drawIndexedPrimitives(type: .triangle,
                                             indexCount: self.indexCount,
                                             indexType: MTLIndexType.uint32,
                                             indexBuffer: self.indexs,
                                             indexBufferOffset: 0)
        /*
         *  不能自动索引持续绘制,
         */
        
        renderEncoder?.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer?.present(drawable)
        
        commandBuffer?.commit()
    }
    

}
