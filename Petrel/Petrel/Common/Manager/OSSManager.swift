//
//  OSSManager.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/13.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AliyunOSSiOS

class OSSManager {
    
    static func upload(images: [UIImage], completion: @escaping ((Error?,[String]?) -> Void)) {
        OSSNetworkService.ossAccess().asObservable().subscribe(onNext: { (oss) in
            OSSManager.upload(oss: oss, images: images, completion: completion)
        }).dispose()
    }
    
    fileprivate static func upload(oss: OSSAccessModel, images: Array<UIImage>, completion: @escaping ((Error?,[String]?) -> Void)) {
        guard images.count > 0 else {
            return
        }

        let imgNames: NSMutableArray = images.map{String(Int($0.size.width))} as! NSMutableArray
        
        let provider = OSSAuthCredentialProvider(authServerUrl: oss.stsServerUrl)
        let client = OSSClient(endpoint: oss.endPoint, credentialProvider: provider)
        
        let group = DispatchGroup()
        (images as NSArray).enumerateObjects { (item, index, _) in
            let put: OSSPutObjectRequest = OSSPutObjectRequest()
            put.bucketName = oss.bucket
            let imagename = oss.visitUrl + "liemi/" + NSUUID().uuidString + ".jpg"
            put.objectKey = imagename
            put.contentType = "image/jpeg"
            put.uploadingData = (item as! UIImage).jpegData(compressionQuality: 1)!
            
            let putTask = client.putObject(put)
            group.enter()
            putTask.continue({ (task) -> Any? in
                group.leave()
                if task.error == nil {
                    imgNames.replaceObject(at: index, with: imagename)
                }else {
                    completion(task.error, nil)
                }
                return nil
            }, cancellationToken: nil)
            
        }
        group.notify(queue: .main) {
            completion(nil, imgNames as? [String])
        }
    }
    
}
