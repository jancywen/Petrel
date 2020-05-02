//
//  RenderContentViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/2.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import MetalKit

class RenderContentViewController: UIViewController {

    var _view: MTKView!
    var _render: ContentRenderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        _view = MTKView(frame: view.bounds, device: MTLCreateSystemDefaultDevice())
        _view.enableSetNeedsDisplay = true
//        _view.device = MTLCreateSystemDefaultDevice()
        _view.clearColor = MTLClearColorMake(0, 0.5, 1.0, 1.0)
        
        _render = ContentRenderer(mtkview: _view)
        _render.mtkView(_view, drawableSizeWillChange: _view.drawableSize)
        _view.delegate = _render
        
        view.addSubview(_view)
    }
}
