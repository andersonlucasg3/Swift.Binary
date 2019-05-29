//
//  BinaryStream.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

struct BinaryStream {
    fileprivate init() { }
    
    fileprivate static func pointer<T>(from value: T) -> UnsafeBufferPointer<UInt8> {
        var value = value
        return withUnsafeBytes(of: &value, { $0.bindMemory(to: UInt8.self) })
    }
    
    static func insert(type: ValueType, is array: Bool, into data: inout Data) throws {
        data.append(self.pointer(from: type.rawValue))
        data.append(self.pointer(from: array))
    }
    
    static func insert<T: Encodable>(value: T, for key: String, into data: inout Data) throws {
        let keyLength = key.lengthOfBytes(using: .utf8)
        data.append(self.pointer(from: keyLength))
        data.append(key.data(using: .utf8)!)
        try self.insert(value: value, into: &data)
    }
    
    static func insert<T: Encodable>(value: T, into data: inout Data) throws {
        switch try ValueType.from(type: T.self) {
        case .int:
            data.append(self.pointer(from: Int64.init(value as! Int)))
            
        case .int8, .int16, .int32, .int64, .float, .double, .bool:
            data.append(self.pointer(from: value))
            
        case .data, .string:
            let countable = value as! Countable
            data.append(self.pointer(from: countable.length))
            data.append(countable.data)
            
        case .object,
             .arrayInt, .arrayInt8, .arrayInt16, .arrayInt32, .arrayInt64,
             .arrayFloat, .arrayDouble, .arrayBool,
             .arrayString, .arrayData, .arrayObject:
            throw BinaryEncoderError.typeNotExpected(type: T.self)
        }
    }
}
