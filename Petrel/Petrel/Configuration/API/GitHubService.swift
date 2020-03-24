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
import Moya

struct GitHubNetworkService {
    static func searchRepositories(query: String) -> Observable<GitHubRepositories> {
        provider.rx.request(MultiTarget(GitHubAPI.verify(query)))
            .filterSuccessfulStatusCodes()
            .map(to: GitHubRepositories.self)
            .asObservable()
            .catchError { (error) -> Observable<GitHubRepositories> in
                return Observable<GitHubRepositories>.empty()
        }
    }
    
    
    static func usernameAvailable(_ username: String) -> Observable<Bool>
    {
        
        provider.rx.request(MultiTarget(GitHubAPI.verify(username))).map {(response) -> Bool in
            print("******\n \(response.statusCode) \n********")
            return response.statusCode == 404
            }.asObservable().catchErrorJustReturn(false)
    }
    
    
    static func signup(_ username: String, password: String) -> Observable<Bool> {
        let signupResult = arc4random() % 3 == 0 ? false : true
        return Observable.just(signupResult).delay(1.5, scheduler: MainScheduler.instance)
    }
}
