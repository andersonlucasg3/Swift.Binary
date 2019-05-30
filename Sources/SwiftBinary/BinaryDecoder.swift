//
//  BinaryDecoder.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 29/05/19.
//

import Foundation

class BinaryDecoder {
    func decode<T>(type: T.Type, from data: Data) throws -> T where T: Decodable {
        
    }
}

internal class BinaryDec: Decoder {
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey : Any]
    
    init(
    
    func container<Key>(keyedBy type: Key.Type) throws -> DecKeyedContainer<Key> where Key : CodingKey {
        
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        
    }
}
