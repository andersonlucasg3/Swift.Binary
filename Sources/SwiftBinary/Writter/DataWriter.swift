//
//  DataWriter.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 28/05/19.
//

import Foundation

class DataWriter: WriterProtocol {
    typealias Buffer = Data
    
    fileprivate(set) var buffer: Data
    
    init() {
        self.buffer = Data.init()
    }
    
    fileprivate func pointer<T>(from value: T) -> UnsafeBufferPointer<UInt8> {
        var value = value
        return withUnsafeBytes(of: &value, { $0.bindMemory(to: UInt8.self) })
    }
    
    fileprivate func insert<T>(_ value: T) {
        self.buffer.append(self.pointer(from: value))
    }
    
    fileprivate func insert(_ data: Data) {
        self.buffer.append(data)
    }
    
    func insert(type: ValueType, is array: Bool) throws {
        self.buffer.append(self.pointer(from: type.rawValue))
        self.buffer.append(self.pointer(from: array))
    }
    
    func insert(key: String) throws {
        let keyLength = key.lengthOfBytes(using: .utf8)
        self.buffer.append(self.pointer(from: keyLength))
        self.buffer.append(key.data(using: .utf8)!)
    }
    
    func insert(value: Int) throws {
        self.insert(value)
    }
    
    func insert(value: UInt) throws {
        self.insert(value)
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
        try self.insert(value: Int32.init(array.count))
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
