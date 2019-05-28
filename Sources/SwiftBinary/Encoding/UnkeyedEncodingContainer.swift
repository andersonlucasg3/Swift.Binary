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
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
    }
}

extension _BinaryEncoder.UnkeyedContainer: UnkeyedEncodingContainer {
    func encodeNil() throws {
        
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        
    }
    
    func superEncoder() -> Encoder {
        
    }
}

extension _BinaryEncoder.UnkeyedContainer: BinaryEncodingContainer {}
