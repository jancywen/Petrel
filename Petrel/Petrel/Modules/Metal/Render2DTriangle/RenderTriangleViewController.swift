//
//  RenderTriangleViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/2.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import MetalKit

class RenderTriangleViewController: UIViewController {
    var _view: MTKView!
    var _aaplrender: AAPLRenderer!
    
    var _triangleRenderer: TriangleRenderer!
    
    var oc: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Render 2D Triangle"
        
        if oc {
            isOC()
        }else {
            isSwift()
        }
        
    }
    
    func isSwift() {
        _view = MTKView(frame: view.bounds, device: MTLCreateSystemDefaultDevice())
        view = _view
        _view.enableSetNeedsDisplay = true
        _triangleRenderer = TriangleRenderer(mtkview: _view)
        _triangleRenderer.mtkView(_view, drawableSizeWillChange: _view.drawableSize)
        _view.delegate = _triangleRenderer
    }
    func isOC() {
        _view = MTKView(frame: view.bounds, device: MTLCreateSystemDefaultDevice())
        view = _view
        _view.enableSetNeedsDisplay = true
        _aaplrender = AAPLRenderer(metalKitView: _view)
        _aaplrender.mtkView(_view, drawableSizeWillChange: _view.drawableSize)
        _view.delegate = _aaplrender
    }
    
}
