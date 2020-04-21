//
//  EditCellViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/4/20.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class EditCellViewController: UIViewController {
    var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    
    var tableIsEditing: Bool = false
    
    var selectedRows = [Int]()
    var number = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "编辑cell"
        
        tableView = UITableView(frame: self.view.frame, style: .plain)
        view.addSubview(tableView)
        
        
//        let sections = Observable.just([EditCellModel(header: "",
//                                                      items: ["cell",
//                                                              "cell",
//                                                              "cell",
//                                                              "cell",
//                                                              "cell",
//                                                              "cell",
//                                                              "cell",
//                                                              "cell",
//                                                              "cell",
//                                                              "cell", ])])
//
//        let dataSource = RxTableViewSectionedAnimatedDataSource<EditCellModel>(configureCell: { (ds, tv, ip, item) -> UITableViewCell in
//            let cell = tv.dequeueCell(UITableViewCell.self)!
//            cell.textLabel?.text = item
//            cell.backgroundColor = .purple
//            return cell
//        })
//
//
//        sections.asDriver(onErrorJustReturn: []).drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
//
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
//        tableView.rx.setDataSource(self).disposed(by: disposeBag)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let item = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(itemAction(_:)))
        let reItem = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(reloadDataTable))
        navigationItem.rightBarButtonItems = [item, reItem]
    }
    
    
    @objc func itemAction(_ sender: UIBarButtonItem) {
        tableIsEditing = !tableIsEditing
        selectedRows.removeAll()
        tableView.allowsMultipleSelectionDuringEditing = tableIsEditing
        tableView.setEditing(tableIsEditing, animated: true)

    }
    @objc func reloadDataTable() {
        number += 10
        tableView.reloadData()
//        tableView.selectRow(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.none)
    }

}

extension EditCellViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(EditCell.self) as! EditCell
        cell.label.text =  "\(indexPath.section)区 \(indexPath.row)行"
        if tableIsEditing, let _ = selectedRows.firstIndex(of: indexPath.row) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            
        }
        cell.selectedBackgroundView = UIView()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableIsEditing
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableIsEditing {
            selectedRows.append(indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableIsEditing {
            if let index = selectedRows.firstIndex(of: indexPath.row) {
                selectedRows.remove(at: index)
            }
        }
    }
    
}

struct EditCellModel {
    var header: String
    var items: [Item]
}
extension EditCellModel: AnimatableSectionModelType {
    typealias Item = String
    var identity: String {
        return header
    }
    init(original: EditCellModel, items: [Self.Item]) {
        self = original
        self.items = items
    }
}
