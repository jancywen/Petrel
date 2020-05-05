//
//  PanoramaRenderer.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/4.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import MetalKit
import GLKit

class PanoramaRenderer: NSObject, MTKViewDelegate {

    var mtkView: MTKView!
    
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var texture: MTLTexture!
    var verties: MTLBuffer!
    var verticesCount: Int!
    
    var viewportSize: vector_uint2!
    
    var angle: Float = 0.0, angleLook: Float = 0.0
    
    var rotationEyePosition: Bool! = false
    var rotationEyeLookat: Bool! = false
    var sliderValue: Float = 0.01
    
    var eyePosition: GLKVector3!
    var lookAtPosition: GLKVector3!
    var upVector: GLKVector3!

    
    init(mtkView: MTKView) {
        self.mtkView = mtkView
        super.init()
        self.setupPipeline()
        self.setupVertex()
        self.setupTexture()
        
        // 观察参数的初始化
        self.eyePosition = GLKVector3Make(0.0, 0.0, 0.0);
        self.lookAtPosition = GLKVector3Make(0.0, 0.0, 0.0);
        self.upVector = GLKVector3Make(0.05, 0.0, 0.05);

    }
    
    func setupPipeline() {
        
        let defaultLibrary = self.mtkView.device?.makeDefaultLibrary()
        let vertexFunction = defaultLibrary?.makeFunction(name: "panorVertexShader")
        let fragmentFunction = defaultLibrary?.makeFunction(name: "panorSamplingShader")
        
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
        let vertex = [
            PanoramaVertex(position: vector_float4(-6.0, 6.0, 6.0, 1.0), color: vector_float3(1.0, 0.0, 0.0), textureCoordinate: vector_float2(0.0, 2.0/6)),
            
            PanoramaVertex(position: vector_float4(-6.0, -6.0, 6.0, 1.0), color: vector_float3(0.0, 0.0, 1.0), textureCoordinate: vector_float2(0.0, 3.0/6)),//左下 2
            PanoramaVertex(position: vector_float4(6.0, -6.0, 6.0, 1.0), color: vector_float3(1.0, 1.0, 1.0), textureCoordinate: vector_float2(1.0, 3.0/6)),//右下 3

            PanoramaVertex(position: vector_float4(-6.0, 6.0, 6.0, 1.0), color: vector_float3(1.0, 0.0, 0.0), textureCoordinate: vector_float2(0.0, 2.0/6)),//左上 0
            PanoramaVertex(position: vector_float4(6.0, 6.0, 6.0, 1.0), color: vector_float3(0.0, 1.0, 0.0), textureCoordinate: vector_float2(1.0, 2.0/6)),//右上 1
            PanoramaVertex(position: vector_float4(6.0, -6.0, 6.0, 1.0), color: vector_float3(1.0, 1.0, 1.0), textureCoordinate: vector_float2(1.0, 3.0/6)),//右下 3


            // 下面
            PanoramaVertex(position: vector_float4(-6.0, 6.0, -6.0, 1.0), color: vector_float3(1.0, 0.0, 0.0), textureCoordinate: vector_float2(0.0, 4.0/6)),//左上 4
            PanoramaVertex(position: vector_float4(6.0, 6.0, -6.0, 1.0), color: vector_float3(0.0, 1.0, 0.0), textureCoordinate: vector_float2(1.0, 4.0/6)),//右上 5
            PanoramaVertex(position: vector_float4(6.0, -6.0, -6.0, 1.0), color: vector_float3(1.0, 1.0, 1.0), textureCoordinate: vector_float2(1.0, 3.0/6)),//右下 7

            PanoramaVertex(position: vector_float4(-6.0, 6.0, -6.0, 1.0), color: vector_float3(1.0, 0.0, 0.0), textureCoordinate: vector_float2(0.0, 4.0/6)),//左上 4
            PanoramaVertex(position: vector_float4(-6.0, -6.0, -6.0, 1.0), color: vector_float3(0.0, 0.0, 1.0), textureCoordinate: vector_float2(0.0, 3.0/6)),//左下 6
            PanoramaVertex(position: vector_float4(6.0, -6.0, -6.0, 1.0), color: vector_float3(1.0, 1.0, 1.0), textureCoordinate: vector_float2(1.0, 3.0/6)),//右下 7
            
            // 左面
            PanoramaVertex(position: vector_float4(-6.0, 6.0, 6.0, 1.0), color: vector_float3(1.0, 0.0, 0.0), textureCoordinate: vector_float2(0.0, 1.0/6)),//左上 0
            PanoramaVertex(position: vector_float4(-6.0, -6.0, 6.0, 1.0), color: vector_float3(0.0, 0.0, 1.0), textureCoordinate: vector_float2(1.0, 1.0/6)),//左下 2
            PanoramaVertex(position: vector_float4(-6.0, 6.0, -6.0, 1.0), color: vector_float3(1.0, 0.0, 0.0), textureCoordinate: vector_float2(0.0, 2.0/6)),//左上 4

            PanoramaVertex(position: vector_float4(-6.0, -6.0, 6.0, 1.0), color: vector_float3(0.0, 0.0, 1.0), textureCoordinate: vector_float2(1.0, 1.0/6)),//左下 2
            PanoramaVertex(position: vector_float4(-6.0, 6.0, -6.0, 1.0), color: vector_float3(1.0, 0.0, 0.0), textureCoordinate: vector_float2(0.0, 2.0/6)),//左上 4
            PanoramaVertex(position: vector_float4(-6.0, -6.0, -6.0, 1.0), color: vector_float3(0.0, 0.0, 1.0), textureCoordinate: vector_float2(1.0, 2.0/6)),//左下 6


            // 右面
            PanoramaVertex(position: vector_float4(6.0, 6.0, 6.0, 1.0), color: vector_float3(0.0, 1.0, 0.0), textureCoordinate: vector_float2(1.0, 0.0/6)),//右上 1
            PanoramaVertex(position: vector_float4(6.0, -6.0, 6.0, 1.0), color: vector_float3(1.0, 1.0, 1.0), textureCoordinate: vector_float2(0.0, 0.0/6)),//右下 3
            PanoramaVertex(position: vector_float4(6.0, 6.0, -6.0, 1.0), color: vector_float3(0.0, 1.0, 0.0), textureCoordinate: vector_float2(1.0, 1.0/6)),//右上 5

            PanoramaVertex(position: vector_float4(6.0, -6.0, 6.0, 1.0), color: vector_float3(1.0, 1.0, 1.0), textureCoordinate: vector_float2(0.0, 0.0/6)),//右下 3
            PanoramaVertex(position: vector_float4(6.0, 6.0, -6.0, 1.0), color: vector_float3(0.0, 1.0, 0.0), textureCoordinate: vector_float2(1.0, 1.0/6)),//右上 5
            PanoramaVertex(position: vector_float4(6.0, -6.0, -6.0, 1.0), color: vector_float3(1.0, 1.0, 1.0), textureCoordinate: vector_float2(0.0, 1.0/6)),//右下 7
            
            // 前面
            PanoramaVertex(position: vector_float4(-6.0, -6.0, 6.0, 1.0), color: vector_float3(0.0, 0.0, 1.0), textureCoordinate: vector_float2(0.0, 4.0/6)),//左下 2
            PanoramaVertex(position: vector_float4(6.0, -6.0, 6.0, 1.0), color: vector_float3(1.0, 1.0, 1.0), textureCoordinate: vector_float2(1.0, 4.0/6)),//右下 3
            PanoramaVertex(position: vector_float4(6.0, -6.0, -6.0, 1.0), color: vector_float3(1.0, 1.0, 1.0), textureCoordinate: vector_float2(1.0, 5.0/6)),//右下 7

            PanoramaVertex(position: vector_float4(-6.0, -6.0, 6.0, 1.0), color: vector_float3(0.0, 0.0, 1.0), textureCoordinate: vector_float2(0.0, 4.0/6)),//左下 2
            PanoramaVertex(position: vector_float4(-6.0, -6.0, -6.0, 1.0), color: vector_float3(0.0, 0.0, 1.0), textureCoordinate: vector_float2(0.0, 5.0/6)),//左下 6
            PanoramaVertex(position: vector_float4(6.0, -6.0, -6.0, 1.0), color: vector_float3(1.0, 1.0, 1.0), textureCoordinate: vector_float2(1.0, 5.0/6)),//右下 7

            // 后面
            PanoramaVertex(position: vector_float4(-6.0, 6.0, 6.0, 1.0), color: vector_float3(1.0, 0.0, 0.0), textureCoordinate: vector_float2(1.0, 5.0/6)),//左上 0
            PanoramaVertex(position: vector_float4(6.0, 6.0, 6.0, 1.0), color: vector_float3(0.0, 1.0, 0.0), textureCoordinate: vector_float2(0.0, 5.0/6)),//右上 1
            PanoramaVertex(position: vector_float4(6.0, 6.0, -6.0, 1.0), color: vector_float3(0.0, 1.0, 0.0), textureCoordinate: vector_float2(0.0, 6.0/6)),//右上 5

            PanoramaVertex(position: vector_float4(-6.0, 6.0, 6.0, 1.0), color: vector_float3(1.0, 0.0, 0.0), textureCoordinate: vector_float2(1.0, 5.0/6)),//左上 0
            PanoramaVertex(position: vector_float4(-6.0, 6.0, -6.0, 1.0), color: vector_float3(1.0, 0.0, 0.0), textureCoordinate: vector_float2(1.0, 6.0/6)),//左上 4
            PanoramaVertex(position: vector_float4(6.0, 6.0, -6.0, 1.0), color: vector_float3(0.0, 1.0, 0.0), textureCoordinate: vector_float2(0.0, 6.0/6)),//右上 5
            
            /*
            // 上面的四个点
            {{-6.0, 6.0, 6.0, 1.0},      {1.0, 0.0, 0.0},       {0.0, 1.0}},//左上 0
            {{6.0, 6.0, 6.0, 1.0},       {0.0, 1.0, 0.0},       {1.0, 1.0}},//右上 1
            {{-6.0, -6.0, 6.0, 1.0},     {0.0, 0.0, 1.0},       {0.0, 0.0}},//左下 2
            {{6.0, -6.0, 6.0, 1.0},      {1.0, 1.0, 1.0},       {1.0, 0.0}},//右下 3
            
            // 下面的四个点
            {{-6.0, 6.0, -6.0, 1.0},     {1.0, 0.0, 0.0},       {0.0, 1.0}},//左上 4
            {{6.0, 6.0, -6.0, 1.0},      {0.0, 1.0, 0.0},       {1.0, 1.0}},//右上 5
            {{-6.0, -6.0, -6.0, 1.0},    {0.0, 0.0, 1.0},       {0.0, 0.0}},//左下 6
            {{6.0, -6.0, -6.0, 1.0},     {1.0, 1.0, 1.0},       {1.0, 0.0}},//右下 7
             */

                      
        ]
        self.verties = self.mtkView.device?.makeBuffer(bytes: vertex, length: vertex.count * MemoryLayout<PanoramaVertex>.size, options: .storageModeShared)
        self.verticesCount = vertex.count
    }
    
    func setupTexture() {
        guard let image = UIImage(named: "panorama") else {
            return
        }
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = .rgba8Unorm
        textureDescriptor.width = Int(image.size.width)
        textureDescriptor.height = Int(image.size.height)
        
        self.texture = self.mtkView.device?.makeTexture(descriptor: textureDescriptor)
        let region = MTLRegionMake3D(0, 0, 0, textureDescriptor.width, textureDescriptor.height, 1)
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
    
        if self.rotationEyePosition {
            angle += self.sliderValue
        }
        if self.rotationEyeLookat {
            angleLook += self.sliderValue
        }
        // 调整眼睛的位置
        self.eyePosition = GLKVector3Make(2.0 * sinf(angle), 2.0 * cosf(angle), 0.0)
        // 调整观察的位置
//        self.lookAtPosition = GLKVector3Make(2.0 * sinf(angleLook), 2.0 * cosf(angleLook), 2.0)
        
        let size = mtkView.bounds.size
        let aspect = abs(size.width / size.height)
            /**GLKMatrix4MakePerspective 配置透视图
             第一个参数, 类似于相机的焦距, 比如10表示窄角度, 100表示广角 一般65-75;
             第二个参数: 表示时屏幕的纵横比
             第三个, 第四参数: 是为了实现透视效果, 近大远处小, 要确保模型位于远近平面之间
             */
        // 投影变换矩阵
        let projectMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0), Float(aspect), 0.1, 20.0)
        // 模型变换矩阵
        let modelViewMatrix = GLKMatrix4MakeLookAt(self.eyePosition.x,
                                                   self.eyePosition.y,
                                                   self.eyePosition.z,
                                                   self.lookAtPosition.x,
                                                   self.lookAtPosition.y,
                                                   self.lookAtPosition.z,
                                                   self.upVector.x,
                                                   self.upVector.y,
                                                   self.upVector.z)
        
        var matrix = TransformMatrix(transProjectionMatrix: getMetalMatrix(projectMatrix),
                                     transModelViewMatrix: getMetalMatrix(modelViewMatrix))
        
        encoder?.setVertexBytes(&matrix,
                                length: MemoryLayout<TransformMatrix>.size,
                                index: Int(PanorVertexInputIndexMatrix.rawValue))
        
    }
    //MARK: MTKViewDelegate
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewportSize = vector_uint2(UInt32(size.width), UInt32(size.height))
    }
    func draw(in view: MTKView) {
        let commandBuffer = self.commandQueue.makeCommandBuffer()
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0.6, 0.6, 1.0)
        renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadAction.clear
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setViewport(MTLViewport(originX: 0, originY: 0, width: Double(viewportSize.x), height: Double(viewportSize.y), znear: -1.0, zfar: 1.0))
        renderEncoder?.setRenderPipelineState(self.pipelineState)
        
        self.setupMatrixWithEncoder(renderEncoder)
        
        renderEncoder?.setVertexBuffer(self.verties, offset: 0, index: Int(PanorVertexInputIndexVertices.rawValue))
        renderEncoder?.setFragmentTexture(self.texture, index: Int(PanorFragmentInputIndexTexture.rawValue))
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: self.verticesCount)
        renderEncoder?.endEncoding()
        
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer?.present(drawable)
        
        commandBuffer?.commit()
    }
}
