//
//  PanoramaViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/4.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import CoreMotion
import GLKit

class PanoramaViewController: UIViewController {
    
    @IBOutlet weak var eyeSwitch: UISwitch!
    @IBOutlet weak var lookatSwitch: UISwitch!
    @IBOutlet weak var motionLabel: UILabel!
    
    var timer: Timer!

    var mtkView: MTKView!
    var render: PanoramaRenderer!
    
    //运动管理器
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "全景图片"

        mtkView = MTKView(frame: view.bounds, device: MTLCreateSystemDefaultDevice())
        view.insertSubview(mtkView, at: 0)
        
        render = PanoramaRenderer(mtkView: mtkView)
        render.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        mtkView.delegate = render
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (time) in
//            self.mtkView.draw()
            self.getGyroData()
        }
        timer.fire()
        
        getGyroData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }

    @IBAction func switchAction(_ sender: Any) {
        render.rotationEyePosition = eyeSwitch.isOn
        render.rotationEyeLookat = lookatSwitch.isOn
    }
    
    func getGyroData() {
        //判断设备支持情况
        guard motionManager.isGyroAvailable else {
            self.motionLabel.text = "\n当前设备不支持陀螺仪\n"
            return
        }
         
        //获取数据
        self.motionManager.startGyroUpdates()
        if let gyroData = self.motionManager.gyroData {
            let rotationRate = gyroData.rotationRate
            var text = "---当前陀螺仪数据---\n"
            text += "x: \(rotationRate.x)\n"
            text += "y: \(rotationRate.y)\n"
            text += "z: \(rotationRate.z)\n"
            self.motionLabel.text = text
            render.lookAtPosition = GLKVector3Make(2.0 * sinf(Float(rotationRate.x)),
                                                   2.0 * cosf(Float(rotationRate.y)), 2.0 )

//            render.lookAtPosition = GLKVector3Make(Float(rotationRate.x), Float(rotationRate.y), Float(rotationRate.z))
            self.mtkView.draw()
        }
        
//        //设置刷新时间间隔
//        self.motionManager.gyroUpdateInterval = 0.2
//
//        //开始实时获取数据
//        let queue = OperationQueue.current
//        self.motionManager.startGyroUpdates(to: queue!, withHandler: { (gyroData, error) in
//            guard error == nil else {
//                print(error!)
//                return
//            }
//            // 有更新
//            if self.motionManager.isGyroActive {
//                if let rotationRate = gyroData?.rotationRate {
//                    var text = "---当前陀螺仪数据---\n"
//                    text += "x: \(rotationRate.x)\n"
//                    text += "y: \(rotationRate.y)\n"
//                    text += "z: \(rotationRate.z)\n"
//                    self.motionLabel.text = text
//                }
//            }
//        })
    }
}
