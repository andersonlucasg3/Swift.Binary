//
//  StringWriter.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 28/05/19.
//

import Foundation

class StringWriter: WriterProtocol {
    typealias Buffer = String
    
    fileprivate(set) var buffer: String
    
    init() {
        self.buffer = ""
    }
    
    fileprivate func insert(_ value: Any) {
        self.buffer.append("value: \(value) |")
    }
    
    fileprivate func insert(_ data: Data) {
        self.buffer.append(String.init(data: data, encoding: .utf8)!)
    }
    
    func insert(type: ValueType, is array: Bool) throws {
        self.buffer.append("""
            type: \(type.rawValue) |
            array: \(array ? 1 : 0) |\n
            """)
    }
    
    func insert(key: String) throws {
        self.buffer.append("""
            key length: \(key.lengthOfBytes(using: .utf8)) |
            key content: \(key) |\n
            """)
    }
    
    func insert(value: Int) throws {
        self.insert(Int64.init(value))
    }
    
    func insert(value: UInt) throws {
        self.insert(UInt64.init(value))
    }
    
    func insert(value: Int8) throws {
        self.insert(value)
    }
    
    func insert(value: UInt8) throws {
        self.insert(value)
    }
    
    func insert(value: Int16) throws {
        self.insert(value)
    }
    
    func insert(value: UInt16) throws {
        self.insert(value)
    }
    
    func insert(value: Int32) throws {
        self.insert(value)
    }
    
    func insert(value: UInt32) throws {
        self.insert(value)
    }
    
    func insert(value: Int64) throws {
        self.insert(value)
    }
    
    func insert(value: UInt64) throws {
        self.insert(value)
    }
    
    func insert(value: Bool) throws {
        self.insert(value)
    }
    
    func insert(value: Float) throws {
        self.insert(value)
    }
    
    func insert(value: Double) throws {
        self.insert(value)
    }
    
    func insert(value: Countable) throws {
        try self.insert(value: value.length)
        self.insert(value.data)
    }
    
    fileprivate func insertArrayCount<T>(from array: Array<T>) throws {
        self.buffer.append("array count: \(array.count) |\n")
    }
    
    func insert(contentsOf array: Array<Int>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: Int64.init($0)) })
    }
    
    func insert(contentsOf array: Array<UInt>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: UInt64.init($0)) })
    }
    
    func insert(contentsOf array: Array<Int8>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<UInt8>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Int16>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<UInt16>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Int32>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<UInt32>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Int64>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<UInt64>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Bool>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Float>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Double>) throws {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
    
    func insert<C>(contentsOf array: Array<C>) throws where C : Countable {
        try self.insertArrayCount(from: array)
        try array.forEach({ try self.insert(value: $0) })
    }
}
