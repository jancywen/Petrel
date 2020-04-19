//
//  AnimationIndexViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/4/17.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class AnimationIndexViewController: UIViewController {

    var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    var type: AnimationType = .scale
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "动画"
        
        tableView = UITableView(frame: self.view.frame, style: .plain)
        view.addSubview(tableView)
        
        let sections = Observable.just([
            AnimationSectionModel.cell(title: "table view cell 动画",
                                       itmes: [.scale,
                                               .rotation,
                                               .move,
                                               .moveSpring,
                                               .alpha,
                                               .fall,
                                               .shake,
                                               .overTurn,
                                               .toTop,
                                               .springList,
                                               .shrinkToTop,
                                               .layDown,
                                               .rote])
        ])
        
        let datasource = RxTableViewSectionedReloadDataSource<AnimationSectionModel> ( configureCell:{ (ds, tv, ip, item) -> UITableViewCell in
            let cell = tv.dequeueCell(UITableViewCell.self)!
            cell.textLabel?.text = item.title
            cell.backgroundColor = .yellow
            return cell
        }, titleForHeaderInSection: { ds, section in return ds[section].title})
        
        sections.asDriver(onErrorJustReturn: []).drive(tableView.rx.items(dataSource: datasource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(AnimationType.self).subscribe(onNext: selectedCell(_:)).disposed(by: disposeBag)
        tableView.rx.willDisplayCell.subscribe(onNext: displayCell).disposed(by: disposeBag)
    }

}
extension AnimationIndexViewController {
    func selectedCell(_ model: AnimationType) {
        type = model
        tableView.reloadData()
    }
    func displayCell(_ cell: UITableViewCell, _ indexPath: IndexPath) {
        switch type {
        case .scale:
            //xy方向缩放的初始值为0.1
            cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
               //设置动画时间为0.25秒，xy方向缩放的最终值为1
            UIView.animate(withDuration: 0.25) {
                cell.layer.transform=CATransform3DMakeScale(1, 1, 1)
            }
        case .rotation:
            let transform = CATransform3DMakeRotation(.pi*0.5, 0, 1, 0)
            cell.layer.transform = transform
            cell.layer.opacity = 0.0
            UIView.animate(withDuration: 0.25,
                           delay: 0.1 * Double(indexPath.row),
                           options: .curveEaseIn,
                           animations: {
                cell.layer.transform = CATransform3DIdentity
                cell.layer.opacity = 1.0
            }, completion: nil)
            break
        case .move:
            cell.transform = CGAffineTransform(translationX: -ScreenWidth, y: 0)
            UIView.animate(withDuration: 0.25,
                           delay: Double(indexPath.row) * 0.05,
                           options: [],
                           animations: {
                            cell.transform = CGAffineTransform.identity
            }, completion: nil)
            break
        case .moveSpring:
            cell.transform = CGAffineTransform(translationX: -ScreenWidth, y: 0)
            UIView.animate(withDuration: 0.4,
                           delay: Double(indexPath.row) * 0.05,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1/0.7,
                           options: .curveEaseIn, animations: {
                            cell.transform = CGAffineTransform.identity
            }, completion: nil)
        case .alpha:
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.3,
                           delay: Double(indexPath.row) * 0.05,
                           options: .curveEaseIn,
                           animations: {
                            cell.alpha = 1.0
            }, completion: nil)
        case .fall:
            cell.transform = CGAffineTransform(translationX: 0 , y: -ScreenHeight)
            UIView.animate(withDuration: 0.25,
                           delay: Double(13 - indexPath.row) * 0.05,
                           options: .curveEaseInOut,
                           animations: {
                            cell.transform = CGAffineTransform.identity
            }, completion: nil)
        case .shake:
            if indexPath.row/2 == 0 {
                cell.transform = CGAffineTransform(translationX: -ScreenWidth, y: 0)
            }else {
                cell.transform = CGAffineTransform(translationX: ScreenWidth, y: 0)
            }
            UIView.animate(withDuration: 0.4,
                           delay: Double(indexPath.row) * 0.03,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1/0.7,
                           options: .curveEaseIn, animations: {
                            cell.transform = CGAffineTransform.identity
            }, completion: nil)
        case .overTurn:
            cell.layer.opacity = 0.0
            cell.layer.transform = CATransform3DMakeRotation(.pi, 1, 0, 0)
            UIView.animate(withDuration: 0.25,
                           delay: 0.05 * Double(indexPath.row),
                           options: .curveEaseIn,
                           animations: {
                            cell.layer.transform = CATransform3DIdentity
                            cell.layer.opacity = 1.0
            }, completion: nil)
        case .toTop:
            cell.transform = CGAffineTransform(translationX: 0 , y: ScreenHeight)
            UIView.animate(withDuration: 0.35,
                           delay: Double(indexPath.row) * 0.05,
                           options: .curveEaseInOut,
                           animations: {
                            cell.transform = CGAffineTransform.identity
            }, completion: nil)

        case .springList:
            cell.layer.opacity = 0.7
            cell.layer.transform = CATransform3DMakeTranslation(0, -ScreenHeight, 20)
            UIView.animate(withDuration: 0.4,
                           delay: Double(indexPath.row) * 0.05,
                           usingSpringWithDamping: 0.65,
                           initialSpringVelocity: 1/0.65,
                           options: .curveEaseIn, animations: {
                            cell.layer.opacity = 1.0
                            cell.layer.transform = CATransform3DMakeTranslation(0, 0, 20)
            }, completion: nil)
        case .shrinkToTop:
            let rect = cell.convert(cell.bounds, to: tableView)
            cell.transform = CGAffineTransform(translationX: 0, y: -rect.origin.y)
            UIView.animate(withDuration: 0.5) {
                cell.transform = CGAffineTransform.identity
            }
        case .layDown:
            let rect = cell.frame
            var newRect = rect
            newRect.origin.y = CGFloat(indexPath.row * 10)
            cell.frame = newRect
            cell.layer.transform = CATransform3DMakeTranslation(0, 0, CGFloat(indexPath.row*5))
            UIView.animate(withDuration: Double(indexPath.row) * 0.05, animations: {
                cell.frame = rect
            }) { (_) in
                cell.layer.transform = CATransform3DIdentity
            }
            
        case .rote:
            let animation = CABasicAnimation(keyPath: "transform.rotation.y")
            animation.fromValue = NSNumber(value: Double.pi)
            animation.toValue = 0
            animation.duration = 0.3
            animation.isRemovedOnCompletion = false
            animation.repeatCount = 3
            animation.fillMode = .forwards
            animation.autoreverses = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.1, delay: Double(indexPath.row) * 0.25, options: .curveEaseIn, animations: {
                cell.alpha = 1.0
            }) { (_) in
                cell.layer.add(animation, forKey: "rotationYkey")
            }
            
        }
    }
}
