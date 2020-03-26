//
//  URLNavigationMap.swift
//  Petrel
//
//  Created by wangwenjie on 2020/3/25.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation
import URLNavigator
import SwiftyJSON
import SafariServices

struct URLNavigationMap {
    static func initialize(navigator: NavigatorType) {
        navigator.register("petrel://douban") { url, values, context in
            return DouBanViewController()
        }
        
        navigator.register("petrel://urlnav") { _,_,_ in URLNavViewController() }
        
        /// no param
        navigator.register("petrel://noParam") { _,_,_ in NoParamViewController()}
        /// one param
        navigator.register("petrel://oneParam/<name>") { url, values, _ in
            guard let name = values["name"] as? String else {return nil}
            return OneParamViewController(name: name)
        }
        /// multi param
        navigator.register("petrel://multiParam") { (url, values, context) -> UIViewController? in
            guard let name = url.queryParameters["name"],
                let score = url.queryParameters["score"] else {
                return nil
            }
            return MultiParamViewController(name: name, score: score)
        }
        /// set context
        navigator.register("petrel://setContext") { (url, values, context) -> UIViewController? in
            
            guard let channel = context as? Channel else {
                return nil
            }
            let vc = SetContextViewController(channel: channel)
            vc.modalPresentationStyle = .fullScreen
            return vc
        }
        /// model  to json
        navigator.register("petrel://modeltojson/<info>") { url, values, context in

            guard let info = values["info"] as? String, let channel = Channel(jsonData:  JSON(parseJSON: info)) else {
                return nil
            }
            return ModelToJsonViewController(channel: channel)
        }
        
        navigator.register("http://<path:_>", self.webViewControllerFactory)
        navigator.register("https://<path:_>", self.webViewControllerFactory)

        navigator.handle("petrel://alert", self.alert(navigator: navigator))

    }
    
    
    
    private static func webViewControllerFactory(
      url: URLConvertible,
      values: [String: Any],
      context: Any?
    ) -> UIViewController? {
      guard let url = url.urlValue else { return nil }
      return SFSafariViewController(url: url)
    }

    private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
      return { url, values, context in
        guard let title = url.queryParameters["title"] else { return false }
        let message = url.queryParameters["message"]
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        navigator.present(alertController)
        return true
      }
    }

    
}
