//
//  KeyedContainer.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 29/05/19.
//

import Foundation

struct KeyedContainer<Key>: KeyedEncodingContainerProtocol where Key: CodingKey {
    typealias Key = Key
    
    let encoder: BinaryEnc
    
    fileprivate lazy var processor = EncodeTypeProcessor.init(writer: self.encoder.writer)
    
    var codingPath: [CodingKey] {
        return self.encoder.codingPath
    }
    
    init(encoder: BinaryEnc, for key: String?) {
        self.encoder = encoder
        
        self.encoder.writer.insert(type: .object, is: false)
        self.encoder.writer.insert(key: key ?? "")
        self.encoder.writer.insert(keyCount: self.codingPath.count)
    }
    
    func encodeNil(forKey key: Key) throws {
        // do not encode nil values
    }
    
    mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        try self.processor.write(value: value, key: key.stringValue)
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let object = self.encoder.userInfo[.object] as! Encodable
        let encoder = BinaryEnc.init(superEncoder: self.encoder, for: keyType, of: object.property(by: key))
        return KeyedEncodingContainer.init(KeyedContainer<NestedKey>.init(encoder: encoder, for: key.stringValue))
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let object = self.encoder.userInfo[.object] as! Encodable
        let encoder = BinaryEnc.init(superEncoder: self.encoder, for: Key.self, of: object)
        return UnkeyedContainer.init(encoder: encoder, for: key.stringValue)
    }
    
    func superEncoder() -> Encoder {
        return self.encoder.superEncoder!
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        return self.encoder.superEncoder!
    }
}
