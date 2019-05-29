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
    let codingPath: [CodingKey]
    
    fileprivate lazy var processor = EncodeTypeProcessor.init(writer: self.encoder.writer)
    
    init(encoder: BinaryEnc, for key: CodingKey?) {
        self.encoder = encoder
        
        let object = encoder.userInfo[.object] as! Encodable
        self.codingPath = object.keys(type: Key.self)
        
        self.encoder.writer.insert(type: .object, is: false)
        self.encoder.writer.insert(key: key?.stringValue ?? "")
        self.encoder.writer.insert(keyCount: self.codingPath.count)
    }
    
    func encodeNil(forKey key: Key) throws {
        // do not encode nil values
    }
    
    mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        if value is Data || value is String || value is Array<Data> || value is Array<String> {
            try self.processor.write(value: value, key: key.stringValue)
        } else {
            let factory = Factory<Key>.init()
            let object = self.encoder.userInfo[.object] as? Encodable
            try value.encode(to: factory.create(superEncoder: self.encoder, object: object?.property(by: key), for: key))
        }
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let object = self.encoder.userInfo[.object] as! Encodable
        let encoder = BinaryEnc.init(superEncoder: self.encoder, for: keyType, object: object.property(by: key))
        return KeyedEncodingContainer.init(KeyedContainer<NestedKey>.init(encoder: encoder, for: key))
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let object = self.encoder.userInfo[.object] as! Encodable
        let encoder = BinaryEnc.init(superEncoder: self.encoder, for: key, object: object)
        return UnkeyedContainer.init(encoder: encoder, for: key)
    }
    
    func superEncoder() -> Encoder {
        return self.encoder.superEncoder!
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        return self.encoder.superEncoder!
    }
}
