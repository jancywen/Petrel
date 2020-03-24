//
//  DouBanViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DouBanViewController: UIViewController {

    var tableView: UITableView!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "豆瓣音乐"
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
/*
        /// 请求数据
        let channels = DouBanProvider.rx.request(.channels).map(to: DouBan.self).map{$0.channels}.asObservable()
        /// 绑定数据
        channels.bind(to: tableView.rx.items) {(tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = element.name + element.channelId
            cell.accessoryType = .disclosureIndicator
            return cell
        }.disposed(by: disposeBag)
        
        /// 点击事件
        tableView.rx.modelSelected(Channel.self)
            .map{$0.channelId}
            .flatMap{DouBanProvider.rx.request(.playlist($0))}.map{try $0.map(to: Playlist.self)}
            .filter{$0.song.count > 0}
            .map{$0.song[0]}
            .subscribe(onNext: { [weak self](song) in
                print(song.title)
                self?.showAlert(title: "歌曲信息", message: "歌手:\(song.artist)\n歌曲:\(song.title)")
            }).disposed(by: disposeBag)
        
      */
        let channels = DouBanService.loadChannels()
        
        channels.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = element.name + element.channelId
            cell.accessoryType = .disclosureIndicator
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Channel.self)
            .map{$0.channelId}
            .flatMap(DouBanService.loadFirstSong)
            .subscribe(onNext: { [weak self] (song) in
                self?.showAlert(title: "歌曲信息", message: "歌手:\(song.artist)\n歌曲:\(song.title)")
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
