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
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
    }
}

extension _BinaryEncoder.SingleValueContainer: SingleValueEncodingContainer {
    func encodeNil() throws {
        
    }
    
    func encode(_ value: Bool) throws {
        
    }
    
    func encode(_ value: String) throws {
        
    }
    
    func encode(_ value: Double) throws {
        
    }
    
    func encode(_ value: Float) throws {
        
    }
    
    func encode(_ value: Int) throws {
        
    }
    
    func encode(_ value: Int8) throws {
        
    }
    
    func encode(_ value: Int16) throws {
        
    }
    
    func encode(_ value: Int32) throws {
        
    }
    
    func encode(_ value: Int64) throws {
        
    }
    
    func encode(_ value: UInt) throws {
        
    }
    
    func encode(_ value: UInt8) throws {
        
    }
    
    func encode(_ value: UInt16) throws {
        
    }
    
    func encode(_ value: UInt32) throws {
        
    }
    
    func encode(_ value: UInt64) throws {
        
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        
    }
}

extension _BinaryEncoder.SingleValueContainer: BinaryEncodingContainer {}
