//
//  SystemAnimationViewController.swift
//  Petrel
//
//  Created by captain on 2020/7/21.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SystemAnimationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var tav: UITableView!
    /*
     私有type
     let kCATransitionCube = "cube";
     let kCATransitionSuckEffect = "suckEffect";
     let kCATransitionOglFlip = "oglFlip";
     let kCATransitionRippleEffect = "rippleEffect";
     let kCATransitionPageCurl = "pageCurl";
     let kCATransitionPageUnCurl = "pageUnCurl";
     let kCATransitionCameraIrisHollowOpen = "cameraIrisHollowOpen";
     let kCATransitionCameraIrisHollowClose = "cameraIrisHollowClose";
     **/
    
    var currentType: CATransitionType = .fade
    var currentSubType: CATransitionSubtype = .fromLeft

    let typeStringList = ["fade", "moveIn", "push", "reveal", "cube", "suckEffect", "oglFlip", "rippleEffect", "pageCurl", "pageUnCurl", "cameraIrisHollowOpen", "cameraIrisHollowClose"]
    let subTypeList = ["fromLeft", "fromRight", "fromTop", "fromBottom"]
    
    let disposeBag = DisposeBag()
    
    var count = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "typeCell")
        Observable.just(typeStringList)
            .bind(to: tableView.rx.items(cellIdentifier:"typeCell")) { _, str, cell in
                cell.textLabel?.text = str
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { (str) in
                self.currentType = CATransitionType(rawValue: str)
            }).disposed(by: disposeBag)
        
//
        tav.register(UITableViewCell.self, forCellReuseIdentifier: "subTypeCell")
        Observable.just(subTypeList)
            .bind(to: tav.rx.items(cellIdentifier: "subTypeCell")) {_, str, cell in
                cell.textLabel?.text = str
        }.disposed(by: disposeBag)
        tav.rx.modelSelected(String.self).subscribe(onNext: { (str) in
            self.currentSubType = CATransitionSubtype(rawValue: str)
            }).disposed(by: disposeBag)
        
        
//        UIView.transition(with: imageView, duration: <#T##TimeInterval#>, options: <#T##UIView.AnimationOptions#>, animations: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
//        UIView.transition(from: <#T##UIView#>, to: <#T##UIView#>, duration: <#T##TimeInterval#>, options: <#T##UIView.AnimationOptions#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        
//        UIView.animate(withDuration: <#T##TimeInterval#>, delay: <#T##TimeInterval#>, options: <#T##UIView.AnimationOptions#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        
//        UIView.animate(withDuration: <#T##TimeInterval#>, delay: <#T##TimeInterval#>, usingSpringWithDamping: <#T##CGFloat#>, initialSpringVelocity: <#T##CGFloat#>, options: <#T##UIView.AnimationOptions#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        
    }

    @IBAction func animationAction(_ sender: Any) {
        count += 1
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = currentType
        transition.subtype = currentSubType
        imageView.layer.add(transition, forKey: nil)
        imageView.image = UIImage(named:"Bag\(count%2)")
    }
    
}
