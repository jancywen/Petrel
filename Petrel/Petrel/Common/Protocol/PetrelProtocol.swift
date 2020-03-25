//
//  PetrelProtocol.swift
//  Petrel
//
//  Created by wangwenjie on 2020/3/25.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation

protocol ConvertToStringable {
    associatedtype Result: Codable
    var valueString: String { get }
}

extension ConvertToStringable {
    func toString(result: Result) -> String {
        let data = try? JSONEncoder().encode(result)
        guard let da = data else { return "{}" }
        guard let st = String.init(data: da, encoding: .utf8) else { return "{}" }
        return st
    }
}
