//
//  BinaryEncoder.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

public class BinaryEncoder {
    public func encode(_ value: Encodable) throws -> Data {
        let dataWriter = DataWriter.init()
        let enc = BinaryEnc.init(writer: dataWriter, object: value)
        try value.encode(to: enc)
        return dataWriter.buffer
    }
}

internal class BinaryEnc: Encoder {
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey : Any]
    
    let superEncoder: BinaryEnc?
    let writer: WriterProtocol
    
    init(writer: WriterProtocol, object: Encodable? = nil) {
        self.superEncoder = nil
        self.writer = writer
        
        self.codingPath = []
        self.userInfo = object != nil ? [.object: object!] : [:]
    }
    
    init(superEncoder: BinaryEnc, codingPath: [CodingKey] = [], object: Encodable? = nil) {
        self.superEncoder = superEncoder
        self.writer = superEncoder.writer
        self.codingPath = codingPath
        
        self.userInfo = object != nil ? [.object: object!] : [:]
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let encoder = BinaryEnc.init(superEncoder: self, for: Key.self, of: self.userInfo[.object] as? Encodable)
        return KeyedEncodingContainer.init(KeyedContainer<Key>.init(encoder: encoder, for: nil))
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        let encoder = BinaryEnc.init(superEncoder: self)
        return UnkeyedContainer.init(encoder: encoder, for: nil)
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        let encoder = BinaryEnc.init(superEncoder: self)
        return UnkeyedContainer.init(encoder: encoder, for: nil)
    }
}

extension BinaryEnc {
    convenience init<Key>(superEncoder: BinaryEnc, for type: Key.Type?, of object: Encodable?) where Key: CodingKey {
        let keys = object?.mirrored().children.compactMap({ $0.label })
        
        self.init(superEncoder: superEncoder, codingPath: keys?.compactMap({ Key.init(stringValue: $0) }) ?? [], object: object)
    }
}

extension CodingUserInfoKey {
    public static let object: CodingUserInfoKey = CodingUserInfoKey(rawValue: "object")!
}
