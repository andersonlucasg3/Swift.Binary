//
//  UnkeyedEncodingContainer.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

extension _BinaryEncoder {
    final class UnkeyedContainer {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var data: Data
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any], into data: inout Data) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.data = data
        }
    }
}

extension _BinaryEncoder.UnkeyedContainer: UnkeyedEncodingContainer {
    var count: Int {
        return 0
    }
    
    func encodeNil() throws {
        // do not include nil values
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        return KeyedEncodingContainer.init(_BinaryEncoder.KeyedContainer<NestedKey>.init(codingPath: self.codingPath, userInfo: self.userInfo, into: &self.data))
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        return _BinaryEncoder.UnkeyedContainer.init(codingPath: self.codingPath, userInfo: self.userInfo, into: &self.data)
    }
    
    func superEncoder() -> Encoder {
        return _BinaryEncoder.init()
    }
}

extension _BinaryEncoder.UnkeyedContainer: BinaryEncodingContainer {}
