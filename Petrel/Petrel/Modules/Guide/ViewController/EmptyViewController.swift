//
//  EmptyViewController.swift
//  Petrel
//
//  Created by captain on 2020/8/17.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmptyViewController: UIViewController, DZNEmptyDataSetSource {

     var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    var dataSet = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView = UITableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        
        
        let items = Observable.just(self.dataSet)
        items.bind(to: tableView.rx.items) {(tableView , _, element) in
            let cell = tableView.dequeueCell(UITableViewCell.self)
            
            return cell!
        }.disposed(by: disposeBag)
        

        var str = "style margin-left: 129px;"
        
        let regex = try? NSRegularExpression(pattern: "margin-left:\\s*\\w*;", options: NSRegularExpression.Options.caseInsensitive)
        
        if let res = regex?.rangeOfFirstMatch(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count)) {
            
            str.removeSubrange(Range(res, in: str)!)
        }
        
        
        print(str)
        
        
    }


    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        
        let view = UIView()
        view.backgroundColor = .red
        let label = UILabel()
        label.text = ".green"
        label.backgroundColor = .green
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        view.bounds = scrollView.bounds
        
        return view
    }

}
