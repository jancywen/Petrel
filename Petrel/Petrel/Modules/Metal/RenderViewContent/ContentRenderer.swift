//
//  ContentRenderer.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/2.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation
import MetalKit

class ContentRenderer:NSObject {
    
    var _device: MTLDevice?
    
    var _commandQueue: MTLCommandQueue?
    
    init(mtkview: MTKView) {
        _device = mtkview.device
        _commandQueue = _device?.makeCommandQueue()
    }
    
}

extension ContentRenderer:MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {return}
        let commandBuffer = _commandQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder?.endEncoding()
        
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
