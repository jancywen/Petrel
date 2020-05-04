//
//  TransformViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/3.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit

class TransformViewController: UIViewController {

    @IBOutlet weak var xswitch: UISwitch!
    @IBOutlet weak var yswitch: UISwitch!
    @IBOutlet weak var zswitch: UISwitch!
    @IBOutlet weak var slide: UISlider!
    
    var mtkView: MTKView!
    var render: TransformRender!
    
    var make: Bool = false
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "3D 转换"
        mtkView = MTKView(frame: view.bounds, device: MTLCreateSystemDefaultDevice())
//        view = mtkView
        view.insertSubview(mtkView, at: 0)
        mtkView.enableSetNeedsDisplay = true
        
        render = TransformRender(mtkView: mtkView)
        render.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        mtkView.delegate = render
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (time) in
            self.mtkView.draw()
        }
        timer.fire()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    deinit {
        
    }
    @IBAction func switchAction(_ sender: Any) {
        
        render.isX = xswitch.isOn
        render.isY = yswitch.isOn
        render.isZ = zswitch.isOn
        render.sildeValue = slide.value
    }
    

}
