//
//  PromiseViewController.swift
//  Petrel
//
//  Created by geeky on 2020/6/15.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyJSON

class PromiseViewController: UIViewController {
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var blueView: UIView!
    var currentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "异步编程库PromiseKit"
        view.backgroundColor = .white
        
        beginObserve()
        
        currentView = blueView
        
    }
    /// 链式调用
    @IBAction func chainCalls(_ sender: Any) {
    
        _ = cook()
            .then(eat)
            .then(wash)
            .done { data in
            print(data)
        }
        .catch({ (error) in
            print(error.localizedDescription)
        })
    }
    /// 多并发
    @IBAction func multipleConcurrent(_ sender: Any) {
        _ = when(fulfilled: [cook(), eat(data: ""), wash(data: "")]).done({ (list) in
            print(list)
        }).catch({ (error) in
            print(error.localizedDescription)
        })
    }
    /// 延迟操作
    @IBAction func delay(_ sender: Any) {
        after(seconds: 5).done { _ in
            print("延时操作")
            print(Thread.current)
        }
    }
    /// URLSession
    @IBAction func session() {
       
        //请求数据
        func fetchData(args: String) -> Promise<HttpBin>{
            //创建URL对象
            let urlString = "https://httpbin.org/get?\(args)"
            let url = URL(string:urlString)
            //创建请求对象
            let request = URLRequest(url: url!)
             
            //使用PromiseKit的URLSession扩展方法获取数据
            return URLSession.shared.dataTask(.promise, with: request)
                .validate() //这个也是PromiseKit提供的扩展方法，比如自动将 404 转成错误
                .map {
                    //将请求结果转成对象
                    try JSONDecoder().decode(HttpBin.self, from: $0.data)
                }
        }
        
        _ = fetchData(args: "foo=bar").done { (bin) in
            print(bin.url)
        }
    }
    
    
    
    
    @IBAction func firs() {
        firstly {
            return Guarantee<String> { seal in
                seal("some")
            }
        }.done { data in
            print(data)
        }
        
    }
    
    
    //MARK: - 通知
    func beginObserve() {
        // 进入后台
        NotificationCenter.default.observe(once: UIApplication.didEnterBackgroundNotification).done { notification in
           
            print("进入后台")
        }
        // 进入前台
        NotificationCenter.default.observe(once: UIApplication.didBecomeActiveNotification).done { notification in
            print("进入前台")
        }
        // 键盘弹出
        NotificationCenter.default.observe(once: UIResponder.keyboardWillShowNotification).done { notification in
            print("键盘弹出")
        }
        
        let customNotificationName = Notification.Name("customNotification")
        NotificationCenter.default.observe(once: customNotificationName).done { notification in
            
        }
        
    }
    
    // uiview 动画 翻转（上下左右） 卷曲、 分解
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nextView = currentView == blueView ? redView : blueView
        UIView.transition(.promise, from: currentView, to: nextView!, duration: 1,
                          options: [.showHideTransitionViews, .transitionFlipFromLeft, .preferredFramesPerSecond30, .curveEaseInOut])
        .done { success in
            self.currentView = nextView
            print("动画结束")
        }
    }
    
    /// 做饭
    func cook() -> Promise<String> {
        print("开始做饭")
        let p = Promise<String> { resolver in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("做菜完毕")
                resolver.fulfill("青椒炒蛋")
            }
        }
        return p
    }
    
    /// 吃饭
    func eat(data: String) -> Promise<String> {
        print("开始吃饭：\(data)")
        return Promise<String> { resolver in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                print("吃好了")
                resolver.fulfill("一个盘子一个锅")
            }
        }
    }
    /// 刷锅
    func wash(data: String) -> Promise<String> {
        print("开始刷锅： \(data)")
        return Promise<String> {resolver in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                print("刷好了")
                resolver.fulfill("干干净净的厨房")
            }
        }
    }
    /// 买宠物
    func bugDog() -> Promise<Dog> {
        return Promise<Dog> {resolver in
            
        }
    }
}


struct Dog {
    var age: Int?
    var naem: String?
}

struct HttpBin: Codable {
    var origin: String
    var url: String
}
