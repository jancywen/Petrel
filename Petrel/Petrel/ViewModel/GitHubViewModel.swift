//
//  GitHubViewModel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import RxSwift
import Result

class GitHubViewModel {
    
    /// 查询行为
    fileprivate let searchAction: Observable<String>
    
    /// 所有的查询结果
    let searchResult: Observable<GitHubRepositories>
    
    /// 查询结果里的资源列表
    let repositories: Observable<[GitHubRepository]>
    
    /// 清空结果z动作
    let cleanResult: Observable<Void>
    
    let navigationTitle: Observable<String>
    
    init(searchAction: Observable<String>) {
        
        self.searchAction = searchAction
        
        self.searchResult = searchAction
            .filter{!$0.isEmpty}
            .flatMapFirst(GitHubNetworkService.searchRepositories)
            .share(replay: 1).observeOn(MainScheduler.instance)
        
        self.cleanResult = searchAction.filter{$0.isEmpty}.map{_ in Void()}
        
        self.repositories = Observable.of(searchResult.map{$0.items},
                                          cleanResult.map{[]}).merge()
        self.navigationTitle = Observable.of(searchResult.map{"共有 \($0.totalCount) 个结果"},
                                             cleanResult.map{"GitHub"}).merge()
    }
    
}
