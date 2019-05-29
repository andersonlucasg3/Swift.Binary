//
//  Encodable.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 29/05/19.
//

import Foundation

extension Encodable {
    func mirrored() -> Mirror {
        return Mirror.init(reflecting: self)
    }
    
    func property<Key>(by key: Key) -> Encodable? where Key: CodingKey {
        let mirror = Mirror.init(reflecting: self)
        return mirror.children.first(where: { $0.label == key.stringValue })?.value as! Encodable?
    }
}
