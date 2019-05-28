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
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any], into data: inout Data) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.data = data
        }
    }
}

extension _BinaryEncoder.KeyedContainer: KeyedEncodingContainerProtocol {
    func encodeNil(forKey key: Key) throws {
        
    }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        
    }
    
    func superEncoder() -> Encoder {
        
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        
    }
}

extension _BinaryEncoder.KeyedContainer: BinaryEncodingContainer {}
