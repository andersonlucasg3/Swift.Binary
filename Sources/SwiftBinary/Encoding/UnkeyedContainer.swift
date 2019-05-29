//
//  UnkeyedContainer.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 29/05/19.
//

import Foundation

struct UnkeyedContainer: UnkeyedEncodingContainer, SingleValueEncodingContainer {
    var codingPath: [CodingKey] = []
    
    var encoder: BinaryEnc
    
    fileprivate lazy var processor = EncodeTypeProcessor.init(writer: self.encoder.writer)
    
    var count: Int {
        return (self.encoder.userInfo[.object] as! Array<Any>).count
    }
    
    init(encoder: BinaryEnc, for key: String?) {
        self.encoder = encoder
    }
    
    mutating func encodeNil() throws {
        // do not include nil values
    }
    
    mutating func encode<T>(_ value: T) throws where T: Encodable {
        try self.processor.write(value: value, key: "")
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        return KeyedEncodingContainer.init(KeyedContainer<NestedKey>.init(encoder: self.encoder, for: nil))
    }
    
    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedContainer.init(encoder: self.encoder, for: nil)
    }
    
    mutating func superEncoder() -> Encoder {
        return self.encoder.superEncoder!
    }
}
