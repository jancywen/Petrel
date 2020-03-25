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
//        navigator.register("petrel://single") { _,_,_ in URLNavViewController()}
        
//        navigator.register("petrel://multi") { (url, values, context) -> UIViewController? in
//
//            guard let name = url.queryParameters["name"],
//                let score = url.queryParameters["score"] else {
//                return nil
//            }
//            return URLNavViewController(name: name, score: score)
//        }
        
        navigator.register("petrel://any") { (url, values, context) -> UIViewController? in
            
            guard let channel = context as? Channel else {
                return nil
            }
            return URLNavViewController(channel: channel)
        }
                
//        navigator.register("petrel://nav/<info>") { url, values, context in
//
//            guard let info = values["info"] as? String, let channel = Channel(jsonData:  JSON(parseJSON: info)) else {
//                return nil
//            }
//            return URLNavViewController(channel: channel)
//        }
//        navigator.register
//      navigator.register("myapp://user/<int:id>") { ... }
//      navigator.register("myapp://post/<title>") { ... }
//      navigator.handle("myapp://alert") { ... }
        
        
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
