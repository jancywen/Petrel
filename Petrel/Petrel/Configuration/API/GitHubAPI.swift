//
//  GitHubAPI.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation

import Moya

let GitHubProvider = MoyaProvider<GitHubAPI>()

public enum GitHubAPI{
    case repositories(String)
    case verify(String)
}

extension GitHubAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .repositories:
            return URL(string: "https://api.github.com")!
        case .verify:
            return URL(string: "https://github.com")!
        }
    }
    
    public var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        case .verify(let name):
            return "/\(name)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .repositories(let query):
            var params:[String: Any] = [:]
            params["q"] = query
            params["sort"] = "stars"
            params["order"] = "desc"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .verify:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}
