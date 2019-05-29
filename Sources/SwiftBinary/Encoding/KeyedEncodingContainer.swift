//
//  KeyedEncodingContainer.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

extension _BinaryEncoder {
    
    final class KeyedContainer<Key> where Key: CodingKey {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var data: Data
        
        let encoder: Encoder
        
        init(encoder: Encoder, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any], into data: inout Data) {
            self.encoder = encoder
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.data = data
        }
    }
    
}

extension _BinaryEncoder.KeyedContainer: KeyedEncodingContainerProtocol {
    func encodeNil(forKey key: Key) throws {
        // do not include nil values
    }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        let valueType = try ValueType.from(type: T.self)
        switch valueType {
        case .int, .int8, .int16, .int32, .int64, .bool, .float, .double, .string, .data:
            try BinaryStream.insert(type: valueType, is: false, into: &self.data)
            try BinaryStream.insert(value: value, for: key.stringValue, into: &self.data)
            
        case .arrayInt:
            try BinaryStream.insert(type: valueType, is: true, into: &self.data)
            let array = value as! Array<Int>
//            array.forEach({ try BinaryStream.insert(value: Int64.init($0), into: &self.data) })
            
//            .arrayInt8, .arrayInt16, .arrayInt32, .arrayInt64,
//             .arrayBool, .arrayFloat, .arrayDouble, .arrayString, .arrayData:
            
        case .object, .arrayObject:
            throw BinaryEncoderError.typeNotExpected(type: T.self)
        }
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        return self.encoder.unke
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        return KeyedEncodingContainer.init(_BinaryEncoder.KeyedContainer.init(codingPath: self.codingPath, userInfo: self.userInfo, into: &self.data))
    }
    
    func superEncoder() -> Encoder {
        return _BinaryEncoder.init()
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        return _BinaryEncoder.init()
    }
}

extension _BinaryEncoder.KeyedContainer: BinaryEncodingContainer {}
