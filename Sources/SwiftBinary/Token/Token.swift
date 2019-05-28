//
//  Token.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

struct Token<T: Codable> {
    fileprivate var type: ValueType
    fileprivate var value: T
    
    init(value: T) throws {
        self.type = try ValueType.from(type: T.self)
        self.value = value
    }

    func encode() -> Data {
        var data = Data.init()
        self.value.encode(to: <#T##Encoder#>)
    }
}
