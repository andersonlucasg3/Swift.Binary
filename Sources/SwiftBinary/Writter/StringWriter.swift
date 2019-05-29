//
//  StringWriter.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 28/05/19.
//

import Foundation

class StringWriter: WriterProtocol, BufferedProtocol {
    typealias Buffer = String
    
    fileprivate(set) var buffer: String
    
    init() {
        self.buffer = ""
    }
    
    fileprivate func insert(_ value: Any) {
        self.buffer.append("\(value)")
    }
    
    fileprivate func insert(_ data: Data) {
        self.buffer.append(String.init(data: data, encoding: .utf8)!)
    }
    
    func insert(type: ValueType, is array: Bool) {
        self.buffer.append("\(type.rawValue)\(array ? 1 : 0)")
    }
    
    func insert(key: String) {
        self.buffer.append("\(key.lengthOfBytes(using: .utf8))\(key)")
    }
    
    func insert(keyCount: Int) {
        self.buffer.append("\(Int16.init(keyCount))")
    }
    
    func insert(value: Int) {
        self.insert(Int64.init(value))
    }
    
    func insert(value: UInt) {
        self.insert(UInt64.init(value))
    }
    
    func insert(value: Int8) {
        self.insert(value)
    }
    
    func insert(value: UInt8) {
        self.insert(value)
    }
    
    func insert(value: Int16) {
        self.insert(value)
    }
    
    func insert(value: UInt16) {
        self.insert(value)
    }
    
    func insert(value: Int32) {
        self.insert(value)
    }
    
    func insert(value: UInt32) {
        self.insert(value)
    }
    
    func insert(value: Int64) {
        self.insert(value)
    }
    
    func insert(value: UInt64) {
        self.insert(value)
    }
    
    func insert(value: Bool) {
        self.insert(value)
    }
    
    func insert(value: Float) {
        self.insert(value)
    }
    
    func insert(value: Double) {
        self.insert(value)
    }
    
    func insert(value: Countable) {
        self.insert(value: value.length)
        self.insert(value.data)
    }
    
    fileprivate func insertArrayCount<T>(from array: Array<T>) {
        self.buffer.append("\(array.count)")
    }
    
    func insert(contentsOf array: Array<Int>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: Int64.init($0)) })
    }
    
    func insert(contentsOf array: Array<UInt>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: UInt64.init($0)) })
    }
    
    func insert(contentsOf array: Array<Int8>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<UInt8>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Int16>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<UInt16>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Int32>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<UInt32>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Int64>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<UInt64>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Bool>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Float>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
    
    func insert(contentsOf array: Array<Double>) {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
    
    func insert<C>(contentsOf array: Array<C>) where C : Countable {
        self.insertArrayCount(from: array)
        array.forEach({ self.insert(value: $0) })
    }
}
