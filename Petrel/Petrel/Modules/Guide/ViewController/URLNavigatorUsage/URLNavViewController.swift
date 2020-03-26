//
//  URLNavViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/3/25.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

class URLNavViewController: UIViewController {

    
    @IBOutlet weak var noParam: UIButton!
    
    @IBOutlet weak var oneParam: UIButton!
    
    @IBOutlet weak var multiParam: UIButton!
    
    @IBOutlet weak var modelToJson: UIButton!
    
    @IBOutlet weak var setContext: UIButton!
    
    @IBOutlet weak var customHandler: UIButton!
    
    @IBOutlet weak var openWeb: UIButton!
    
    
    let disposeBag = DisposeBag()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "URLNavigator 应用"
                
        /// 无参
        noParam.rx.tap.subscribe(onNext:{
            navigator.push("petrel://noParam")
        }).disposed(by: disposeBag)
        /// 单参
        oneParam.rx.tap.subscribe(onNext:{
            navigator.push("petrel://oneParam/LiLei")
        }).disposed(by: disposeBag)
        /// 多参
        multiParam.rx.tap.subscribe(onNext:{
            navigator.push("petrel://multiParam?name=LiLei&score=59")
        }).disposed(by: disposeBag)
        ///model to json
        modelToJson.rx.tap.subscribe(onNext:{
            let channel = Channel(jsonData: JSON(parseJSON: "{\"name\":\"Hally\"}"))
            if let json = channel?.valueString  {
                navigator.push("petrel://modeltojson/\(json)")
            }
        }).disposed(by: disposeBag)
        /// context
        setContext.rx.tap.subscribe(onNext:{
            let channel = Channel(jsonData: JSON(parseJSON: "{\"name\":\"Hally\"}"))
            navigator.push("petrel://setContext", context: channel as Any)
        }).disposed(by: disposeBag)
        /// 自定义操作
        customHandler.rx.tap.subscribe(onNext:{
            navigator.open("petrel://alert?title=Hello&message=World")
        }).disposed(by: disposeBag)
        /// 打开网页
        openWeb.rx.tap.subscribe(onNext:{
            navigator.push("https://baidu.com")
        }).disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
