//
//  RequestToastPlugin.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/29.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import Moya
import Result
import SVProgressHUD
import SwiftyJSON

///处理 特殊 http status code
final class StatusCodePlugin: PluginType {
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        
        print("处理code")
        
        guard case let Result.success(response) = result else { return }
        guard let code = response.response?.statusCode else { return }
        switch code {
        case 200:
            return
        case 401:
            // 跳登录页
            
            break
        default:
            if let message = try? JSON(data: response.data) {
                if let msg = message["message"].string {
                    SVProgressHUD.showError(withStatus: msg)
                }
            }
        }
    }
}

/// 请求过程HUD 吐出错误信息
final class HUDPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        SVProgressHUD.show()
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        SVProgressHUD.dismiss()
        
        guard case let Result.failure(error) = result else { return }
        let message = error.errorDescription ?? "未知错误"
        SVProgressHUD.showError(withStatus: message)
    }
}

/// 授权插件
struct AuthSimplePlugin:PluginType {
    let token: String
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue(token, forHTTPHeaderField: "Authorization")
        return request
    }
}

struct AuthPlugin: PluginType {
    let tokenClosure: () -> String?
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? AuthorizedTargetType, target.needsAuth else {
            return request
        }
        var request = request
        if let token = tokenClosure() {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

/// header  插件
final class HeaderPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

/// 日志插件
struct LogPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        var log = "                                *  *  *  *  *  *"
        log.append("\n")
        log.append("\n")
        log.append("request begin                                ")
        log.append("\n")
        log.append("                                -------------                                ")
        log.append("\n")
        log.append("\n")
        log.append("url: \(target.baseURL.absoluteString + target.path) ")
        log.append("\n")
        
        let task = target.task
        switch task {
        case .requestPlain:
            log.append("para: nil ")
        case .requestParameters(let parameters, let  encoding):
            log.append("                               para: \(parameters) ")
            log.append("\n")
            log.append("                               encoding: \(encoding)")
            log.append("\n")
        default:
            break
        }
        log.append("\n")
        log.append("                               -----------                                ")
        log.append("\n")
        log.append("request end                                ")
        log.append("\n")
        log.append("\n")
        log.append("                                *  *  *  *  *  *")
        log.append("\n")
        print(log)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        var log = "                                *  *  *  *  *  *"
        log.append("\n")
        log.append("\n")
        log.append("response begin                                ")
        log.append("\n")
        log.append("                                -------------                                ")
        log.append("\n")
        log.append("\n")
        log.append("url: \(target.baseURL.absoluteString + target.path) ")
        log.append("\n")
        switch result {
        case .failure(let error):
            
            
            log.append("\n")
            log.append("                               -----------                                ")
            log.append("\n")
            log.append("response failed with \(error.localizedDescription)                             ")
            log.append("\n")
            log.append("\n")
            log.append("                                *  *  *  *  *  *")
            print(log)
        case .success(let s):
            log.append("\n")
            log.append("                               ---------------                                ")
            log.append("\n")
            log.append("response success with                            ")
            log.append("\n")
            log.append("                               ---------------                                ")
            log.append("\n")
            log.append("                               \(JSON(s.data))                            ")
            log.append("\n")
            log.append("\n")
            log.append("\n")
            log.append("                                *  *  *  *  *  *")
            log.append("\n")
            print(log)
        }
    }
}


//let custom_provider = MoyaProvider<MultiTarget>(plugins:[LogPlugin()])
