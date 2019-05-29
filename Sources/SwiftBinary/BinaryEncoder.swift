//
//  BinaryEncoder.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

public class BinaryEncoder {
    public func encode(_ value: Encodable) throws -> Data {
        let encoder = _BinaryEncoder.init()
        try value.encode(to: encoder)
        return encoder.data
    }
}

final class _BinaryEncoder: Encoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    fileprivate(set) var data: Data = Data.init()
    
    fileprivate var container: BinaryEncodingContainer?
}

extension _BinaryEncoder {
    fileprivate func assertCanCreateContainer() {
        precondition(self.container == nil)
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        assertCanCreateContainer()
        
        let container = KeyedContainer<Key>.init(encoder: self, codingPath: self.codingPath, userInfo: self.userInfo, into: &self.data)
        self.container = container
        
        return KeyedEncodingContainer.init(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        assertCanCreateContainer()
        
        let container = UnkeyedContainer.init(codingPath: self.codingPath, userInfo: self.userInfo, into: &self.data)
        self.container = container
        
        return container
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        assertCanCreateContainer()
        
        let container = SingleValueContainer.init(codingPath: self.codingPath, userInfo: self.userInfo, into: &self.data)
        self.container = container
                
        return container
    }
}

protocol BinaryEncodingContainer: class {
    
}
