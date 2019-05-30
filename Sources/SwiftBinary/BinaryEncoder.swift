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
    var codingKey: CodingKey?
    
    fileprivate var factory: BinaryEncFactory!
    
    init(writer: WriterProtocol, object: Encodable? = nil) {
        self.superEncoder = nil
        self.writer = writer
        
        self.codingPath = []
        self.userInfo = object != nil ? [.object: object!] : [:]
    }
    
    init(superEncoder: BinaryEnc, object: Encodable? = nil) {
        self.superEncoder = superEncoder
        self.writer = superEncoder.writer
        self.codingPath = []
        self.userInfo = object != nil ? [ .object: object! ] : [:]
    }
    
    init<Key>(superEncoder: BinaryEnc, for key: Key.Type, object: Encodable? = nil) where Key: CodingKey {
        self.superEncoder = superEncoder
        self.writer = superEncoder.writer
        self.codingPath = object?.keys(type: Key.self) ?? []
        self.factory = Factory<Key>.init()
        
        self.userInfo = object != nil ? [.object: object!] : [:]
    }
    
    convenience init<Key>(superEncoder: BinaryEnc, for key: Key?, object: Encodable? = nil) where Key: CodingKey {
        self.init(superEncoder: superEncoder, for: Key.self, object: object)
        self.codingKey = key
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let object = self.userInfo[.object] as? Encodable
        let encoder = BinaryEnc.init(superEncoder: self, for: type, object: object)
        return KeyedEncodingContainer.init(EncKeyedContainer<Key>.init(encoder: encoder, for: self.codingKey))
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        let object = self.userInfo[.object] as? Encodable
        let encoder = BinaryEnc.init(writer: self.writer, object: object)
        return EncUnkeyedContainer.init(encoder: encoder, for: self.codingKey)
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        let object = self.userInfo[.object] as? Encodable
        let encoder = self.factory.create(superEncoder: self, object: object, for: nil)
        return EncUnkeyedContainer.init(encoder: encoder, for: self.codingKey)
    }
}

protocol BinaryEncFactory {
    func create(superEncoder: BinaryEnc, object: Encodable?, for key: CodingKey?) -> BinaryEnc
}

class Factory<Key> : BinaryEncFactory where Key: CodingKey {
    func create(superEncoder: BinaryEnc, object: Encodable?, for key: CodingKey?) -> BinaryEnc {
        return BinaryEnc.init(superEncoder: superEncoder, for: key as! Key?, object: object)
    }
}

extension CodingUserInfoKey {
    public static let object: CodingUserInfoKey = CodingUserInfoKey(rawValue: "object")!
}
