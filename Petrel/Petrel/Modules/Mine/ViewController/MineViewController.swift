//
//  MineViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/12.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit

import RxDataSources
import RxCocoa
import RxSwift

class MineViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource:RxCollectionViewSectionedReloadDataSource<MineServiceSectionModel>?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = LeftAlignmentLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize(width: 80, height: 72)
        collectionView.setCollectionViewLayout(layout, animated: false)

        
        let viewModel = MineViewModel()
        
        
        let dataSource = sectionDataSouce()
        self.dataSource = dataSource
        
        viewModel.dataSource
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        
    }



}

extension MineViewController {
    func sectionDataSouce() -> RxCollectionViewSectionedReloadDataSource<MineServiceSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<MineServiceSectionModel>(configureCell: {(ds, cv, ip, item) in
            switch item {
            case .item(let type):
                let cell = cv.dequeueCell(MineServiceCell.self, for: ip) as! MineServiceCell
                cell.imageView.image = UIImage(named: type.image)
                cell.label.text = type.title
                return cell
            }
        }
        )
    }
}
