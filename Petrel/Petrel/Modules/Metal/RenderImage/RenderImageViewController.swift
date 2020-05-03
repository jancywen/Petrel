//
//  RenderImageViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/3.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import Metal

class RenderImageViewController: UIViewController {

    
    var mtkView: MTKView!
    var imageRender: ImageRenderer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mtkView = MTKView(frame: view.bounds, device: MTLCreateSystemDefaultDevice())
        view = mtkView
        mtkView.enableSetNeedsDisplay = true
        
        imageRender = ImageRenderer(mtkview: mtkView)
        imageRender.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        mtkView.delegate = imageRender
    }
    
}
