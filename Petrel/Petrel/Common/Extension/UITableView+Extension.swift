//
//  UITableView+extension.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/7.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    private struct AssociatedKeys {
        static var registedCellTag = "registedCellTag"
    }
    
    
    private var registedCell:[String] {
        get {
            guard let registedCell = objc_getAssociatedObject(self, &AssociatedKeys.registedCellTag) as? [String] else {
                return [String]()
            }
            return registedCell
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registedCellTag, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    // MARK: reuse table view cell
    public func dequeueCell<T: UITableViewCell>() -> T? {
        return self.dequeueCell(T.self) as? T
    }
    
    func dequeueCell(_ type: AnyClass) -> UITableViewCell? {
        return self.dequeueCell(type, forCellReuseIdentifier: nil)
    }
    
    func dequeueCell(_ type: AnyClass, forCellReuseIdentifier identifier: String?) -> UITableViewCell? {
        let className = NSStringFromClass(type).components(separatedBy: ".").last!
        let identifier = identifier ?? className
        if !self.registedCell.contains(identifier) {
            if Bundle(for: type).path(forResource: className, ofType: "nib") != nil {
                self.register(UINib(nibName: className, bundle: Bundle(for: type)), forCellReuseIdentifier: identifier)
            }else {
                self.register(type, forCellReuseIdentifier: identifier)
            }
            self.registedCell.append(identifier)
        }
        return self.dequeueReusableCell(withIdentifier: identifier)
    }
    
    
    // MARK: reuse header footer view
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>() -> T? {
        return self.dequeueHeaderFooter(T.self) as? T
    }
    
    func dequeueHeaderFooter(_ type: AnyClass) -> UITableViewHeaderFooterView? {
        let className = NSStringFromClass(type).components(separatedBy: ".").last!
        if !self.registedCell.contains(className) {
            if Bundle(for: type).path(forResource: className, ofType: "nib") != nil {
                self.register(UINib(nibName: className, bundle: Bundle(for: type)), forHeaderFooterViewReuseIdentifier: className)
            }else {
                self .register(type, forHeaderFooterViewReuseIdentifier: className)
            }
            self.registedCell.append(className)
        }
        return self.dequeueReusableHeaderFooterView(withIdentifier: className)
    }
}
