//
//  URLNavViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/3/25.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import RxSwift

class URLNavViewController: UIViewController {

    let disposeBag = DisposeBag()
    /*
     // 传模型
    var channel: Channel
    init(channel: Channel) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    /*
    /// 多个参数
    var name: String
    var score: String
    init(name:String, score: String) {
        self.name = name
        self.score = score
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    
    
    var channel: Channel
    init(channel: Channel) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        
        let pop = UIButton(title: "pop", textColor: .blue, font: .m24)
        self.view.addSubview(pop)
        pop.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(130)
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
        pop.rx.tap.subscribe(onNext: {
            self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        let dismiss = UIButton(title: "dismiss", textColor: .blue, font: .m32)
                self.view.addSubview(dismiss)
                dismiss.snp.makeConstraints { (make) in
                    make.left.equalTo(120)
                    make.top.equalTo(130)
        //            make.size.equalTo(CGSize(width: 50, height: 40))
                }
                dismiss.rx.tap.subscribe(onNext: {
                    self.dismiss(animated: true, completion: nil)
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
