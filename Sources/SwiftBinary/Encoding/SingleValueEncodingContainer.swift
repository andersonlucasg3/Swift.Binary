//
//  SingleValueEncodingContainer.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

extension _BinaryEncoder {
    final class SingleValueContainer {
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

extension _BinaryEncoder.SingleValueContainer: SingleValueEncodingContainer {
    func encodeNil() throws {
        // do not include nil values
    }
    
    func encode(_ value: Bool) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode(_ value: String) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode(_ value: Double) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode(_ value: Float) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode(_ value: Int) throws {
        try BinaryStream.insert(value: Int64.init(value), into: &self.data)
    }
    
    func encode(_ value: Int8) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode(_ value: Int16) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode(_ value: Int32) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode(_ value: Int64) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode(_ value: UInt) throws {
        try BinaryStream.insert(value: UInt64.init(value), into: &self.data)
    }
    
    func encode(_ value: UInt8) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode(_ value: UInt16) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode(_ value: UInt32) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode(_ value: UInt64) throws {
        try BinaryStream.insert(value: value, into: &self.data)
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        try BinaryStream.insert(value: value, into: &self.data)
    }
}

extension _BinaryEncoder.SingleValueContainer: BinaryEncodingContainer {}
