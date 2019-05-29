//
//  EncodeTypeProcessor.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 29/05/19.
//

import Foundation

struct EncodeTypeProcessor {
    fileprivate(set) var writer: WriterProtocol
    
    fileprivate func write(type: ValueType, array: Bool, key: String) {
        self.writer.insert(type: type, is: array)
        self.writer.insert(key: key)
    }
    
    func write<T: Encodable>(value: T) throws {
        switch value {
        case let v as Int: self.writer.insert(value: Int64.init(v))
        case let v as UInt: self.writer.insert(value: UInt64.init(v))
        case let v as Int8: self.writer.insert(value: v)
        case let v as UInt8: self.writer.insert(value: v)
        case let v as Int16: self.writer.insert(value: v)
        case let v as UInt16: self.writer.insert(value: v)
        case let v as Int32: self.writer.insert(value: v)
        case let v as UInt32: self.writer.insert(value: v)
        case let v as Int64: self.writer.insert(value: v)
        case let v as UInt64: self.writer.insert(value: v)
        case let v as Float: self.writer.insert(value: v)
        case let v as Double: self.writer.insert(value: v)
        case let v as Bool: self.writer.insert(value: v)
        case let v as String: self.writer.insert(value: v)
        case let v as Data: self.writer.insert(value: v)
            
        // arrays
        case let v as Array<Int>: self.writer.insert(contentsOf: v)
        case let v as Array<UInt>: self.writer.insert(contentsOf: v)
        case let v as Array<Int8>: self.writer.insert(contentsOf: v)
        case let v as Array<UInt8>: self.writer.insert(contentsOf: v)
        case let v as Array<Int16>: self.writer.insert(contentsOf: v)
        case let v as Array<UInt16>: self.writer.insert(contentsOf: v)
        case let v as Array<Int32>: self.writer.insert(contentsOf: v)
        case let v as Array<UInt32>: self.writer.insert(contentsOf: v)
        case let v as Array<Int64>: self.writer.insert(contentsOf: v)
        case let v as Array<UInt64>: self.writer.insert(contentsOf: v)
        case let v as Array<Float>: self.writer.insert(contentsOf: v)
        case let v as Array<Double>: self.writer.insert(contentsOf: v)
        case let v as Array<Bool>: self.writer.insert(contentsOf: v)
        case let v as Array<String>: self.writer.insert(contentsOf: v)
        case let v as Array<Data>: self.writer.insert(contentsOf: v)
            
        default: throw BinaryEncoderError.typeNotExpected(type: T.self)
        }
    }
    
    func write<T: Encodable>(value: T, key: String) throws {
        switch value {
        case let v as Int:
            self.write(type: .int64, array: false, key: key)
            self.writer.insert(value: Int64.init(v))
        case let v as UInt:
            self.write(type: .int64, array: false, key: key)
            self.writer.insert(value: UInt64.init(v))
        case let v as Int8:
            self.write(type: .int8, array: false, key: key)
            self.writer.insert(value: v)
        case let v as UInt8:
            self.write(type: .int8, array: false, key: key)
            self.writer.insert(value: v)
        case let v as Int16:
            self.write(type: .int16, array: false, key: key)
            self.writer.insert(value: v)
        case let v as UInt16:
            self.write(type: .int16, array: false, key: key)
            self.writer.insert(value: v)
        case let v as Int32:
            self.write(type: .int32, array: false, key: key)
            self.writer.insert(value: v)
        case let v as UInt32:
            self.write(type: .int32, array: false, key: key)
            self.writer.insert(value: v)
        case let v as Int64:
            self.write(type: .int64, array: false, key: key)
            self.writer.insert(value: v)
        case let v as UInt64:
            self.write(type: .int64, array: false, key: key)
            self.writer.insert(value: v)
        case let v as Float:
            self.write(type: .float, array: false, key: key)
            self.writer.insert(value: v)
        case let v as Double:
            self.write(type: .double, array: false, key: key)
            self.writer.insert(value: v)
        case let v as Bool:
            self.write(type: .bool, array: false, key: key)
            self.writer.insert(value: v)
        case let v as String:
            self.write(type: .string, array: false, key: key)
            self.writer.insert(value: v)
        case let v as Data:
            self.write(type: .data, array: false, key: key)
            self.writer.insert(value: v)
            
        // arrays
            
        case let v as Array<Int>:
            self.write(type: .int64, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<UInt>:
            self.write(type: .int64, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<Int8>:
            self.write(type: .int8, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<UInt8>:
            self.write(type: .int8, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<Int16>:
            self.write(type: .int16, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<UInt16>:
            self.write(type: .int16, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<Int32>:
            self.write(type: .int32, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<UInt32>:
            self.write(type: .int32, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<Int64>:
            self.write(type: .int64, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<UInt64>:
            self.write(type: .int64, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<Float>:
            self.write(type: .float, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<Double>:
            self.write(type: .double, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<Bool>:
            self.write(type: .bool, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<String>:
            self.write(type: .string, array: true, key: key)
            self.writer.insert(contentsOf: v)
        case let v as Array<Data>:
            self.write(type: .data, array: true, key: key)
            self.writer.insert(contentsOf: v)
            
        default: throw BinaryEncoderError.typeNotExpected(type: T.self)
        }
    }
}
