//
//  UICollectionView+Extension.swift
//  Petrel
//
//  Created by wangwenjie on 2020/1/2.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation

extension UICollectionView {
    
    enum SectionElementType: String {
        case header
        case footer
        
        var kindString: String {
            return self == .header ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter
        }
    }

    private struct AssociatedKeys {
        static var registedCellTag = "registedCellTag"
    }
    
    private var registedCell: [String] {
        get {
            var registedCell = objc_getAssociatedObject(self, &AssociatedKeys.registedCellTag) as? [String]
            if registedCell == nil {
                registedCell = [String]()
                self.registedCell = registedCell!
            }
            return registedCell!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registedCellTag, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - 创建可复用的UICollectionViewCell
    /// 使用泛型创建可复用的UICollectionViewCell
    ///
    /// - Parameters:
    ///   - indexPath: indexPath
    public func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T? {
        return self.dequeueCell(T.self, for: indexPath) as? T
    }
    
    /// 创建可复用的UICollectionViewCell
    ///
    /// - Parameters:
    ///   - type: UICollectionViewCell类
    ///   - indexPath: indexPath
    @objc public func dequeueCell(_ type: AnyClass, for indexPath: IndexPath) -> UICollectionViewCell? {
        let className = NSStringFromClass(type).components(separatedBy: ".").last!
        if !self.registedCell.contains(className) {
            if Bundle(for: type).path(forResource: className, ofType: "nib") != nil {
                self.register(UINib(nibName: className, bundle: Bundle(for: type)),
                              forCellWithReuseIdentifier: className)
            } else {
                self.register(type, forCellWithReuseIdentifier: className)
            }
            self.registedCell.append(className)
        }
        return self.dequeueReusableCell(withReuseIdentifier: className, for: indexPath)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(of type: SectionElementType, reusable: T.Type,for indexPath: IndexPath) -> T{
        let className = NSStringFromClass(reusable).components(separatedBy: ".").last!
//        guard let cell = self.dequeueReusableSupplementaryView(ofKind: type.kindString, withReuseIdentifier: className, for: indexPath) as? T else {
//            fatalError(
//                "Failed to dequeue a cell with identifier \(className) matching type \(reusable.self). "
//                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
//                    + "and that you registered the cell beforehand"
//            )
//        }
//
        
        if !self.registedCell.contains(className) {
            if Bundle(for: reusable).path(forResource: className, ofType: "nib") != nil {
                self.register(UINib(nibName: className, bundle: Bundle(for: reusable)), forSupplementaryViewOfKind: type.kindString, withReuseIdentifier: className)
            }else {
                self.register(reusable.self, forSupplementaryViewOfKind: type.kindString, withReuseIdentifier: className)
            }
            self.registedCell.append(className)
        }
        
        return self.dequeueReusableSupplementaryView(ofKind: type.kindString, withReuseIdentifier: className, for: indexPath) as! T
    }

}

