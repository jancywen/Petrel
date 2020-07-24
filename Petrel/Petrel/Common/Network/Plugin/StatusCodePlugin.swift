//
//  StatusCodePlugin.swift
//  Petrel
//
//  Created by captain on 2020/7/22.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Moya
import Result
import SVProgressHUD
import SwiftyJSON

///处理 特殊 http status code
final class StatusCodePlugin: PluginType {
    
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        
        return result
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
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
