//
//  UploadViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/18.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func upload(_ sender: Any) {
        
        let data = ["a", "b", "c", "d"]
        let callback: NSMutableArray = ["", "", "", ""]
        let group  = DispatchGroup()
        (data as NSArray).enumerateObjects(options: .concurrent) { (item, index, _) in
            group.enter()
            UploadProvider.request(.upload(item as! String)) { (result) in
                group.leave()
                switch result {
                case let .success(response):
                    let str = String(data: response.data, encoding: .utf8)
                    print(str! + "  index: \(index)")
                    callback.replaceObject(at: index, with: item)
                default:
                    break
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {
            print(callback)
        }
    }
    
}
