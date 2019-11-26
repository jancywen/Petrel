//
//  GitHubViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GitHubViewController: UIViewController {

    var tableView: UITableView!
    
    var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 56))
        tableView.tableHeaderView = searchBar
        
        let searchAction = searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asObservable()
        
        let viewModel = GitHubViewModel(searchAction: searchAction)
        viewModel.navigationTitle.bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.repositories.bind(to: tableView.rx.items){(tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.textLabel?.text = element.name
            cell?.detailTextLabel?.text = element.htmlUrl
            return cell!
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GitHubRepository.self).subscribe(onNext: { [weak  self](repository) in
            self?.showAlert(title: repository.fullName, message: repository.description)
            }).disposed(by: disposeBag)
    }
    
    //显示消息
    func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
