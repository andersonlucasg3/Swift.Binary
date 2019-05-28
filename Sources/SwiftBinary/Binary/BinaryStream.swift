//
//  BinaryStream.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

struct BinaryStream {
    fileprivate init() { }
    
    static func encode<T: Encodable>(value: T?, keyName: String, into data: inout Data) {
        let keyLength: Int32 = Int32.init(keyName.lengthOfBytes(using: .utf8))
        data.append(self.pointer(from: keyLength))
        
        data.append(keyName.data(using: .utf8)!)
        
        if let value = value {
            self.encode(value: value, into: &data)
        }
    }
    
    static func encode<T: Encodable>(value: T?, into data: inout Data) {
        data.append(self.pointer(from: value))
    }
    
    fileprivate static func pointer<T>(from value: T) -> UnsafeBufferPointer<UInt8> {
        var value = value
        return withUnsafeBytes(of: &value, { $0.bindMemory(to: UInt8.self) })
    }
}
