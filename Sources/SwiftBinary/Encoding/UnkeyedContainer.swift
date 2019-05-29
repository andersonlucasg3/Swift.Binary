//
//  UnkeyedContainer.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 29/05/19.
//

import Foundation

struct UnkeyedContainer: UnkeyedEncodingContainer, SingleValueEncodingContainer {
    fileprivate lazy var processor = EncodeTypeProcessor.init(writer: self.encoder.writer)
    fileprivate var insertedTypeAndKey = false
    
    let codingPath: [CodingKey] = []
    
    let encoder: BinaryEnc
    let key: CodingKey?
    let object: Encodable
    
    var count: Int {
        return (self.encoder.userInfo[.object] as! Array<Any>).count
    }
    
    init(encoder: BinaryEnc, for key: CodingKey?) {
        self.encoder = encoder
        self.key = key
        self.object = encoder.userInfo[.object] as! Encodable
        
        let array = self.object as? Array<Encodable>
        
        if let array = array, array.count > 0 {
            self.encoder.writer.insert(type: try! self.getType(from: array.first!), is: true)
        } else {
            self.encoder.writer.insert(type: try! self.getType(from: self.object), is: false)
        }
        self.encoder.writer.insert(key: key?.stringValue ?? "")
        if let array = array {
            self.encoder.writer.insert(value: Int32.init(array.count))
        }
    }
    
    fileprivate func getType(from value: Encodable) throws -> ValueType {
        return try ValueType.from(type: type(of: value))
    }
    
    mutating func encodeNil() throws {
        // do not include nil values
    }
    
    mutating func encode<T>(_ value: T) throws where T: Encodable {
        if try ValueType.from(type: T.self) == .object {
            let encoder = BinaryEnc.init(superEncoder: self.encoder, object: value)
            try value.encode(to: encoder)
        } else {
            try self.processor.write(value: value)
        }
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        return KeyedEncodingContainer.init(KeyedContainer<NestedKey>.init(encoder: self.encoder, for: self.key))
    }
    
    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedContainer.init(encoder: self.encoder, for: self.key)
    }
    
    mutating func superEncoder() -> Encoder {
        return self.encoder.superEncoder!
    }
}
