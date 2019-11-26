//
//  GitHubService.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import RxSwift
import Moya_SwiftyJSONMapper

struct GitHubNetworkService {
    static func searchRepositories(query: String) -> Observable<GitHubRepositories> {
        GitHubProvider.rx.request(.repositories(query))
            .filterSuccessfulStatusCodes()
            .map(to: GitHubRepositories.self)
            .asObservable()
            .catchError { (error) -> Observable<GitHubRepositories> in
                return Observable<GitHubRepositories>.empty()
        }
    }
}
