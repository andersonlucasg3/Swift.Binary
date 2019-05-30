//
//  StringReader.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 29/05/19.
//

import Foundation

class StringReader: ReaderProtocol, BufferedProtocol {
    typealias Buffer = Array<String>
    
    fileprivate(set) var buffer: Buffer
    fileprivate var currentPos: Int
    
    init(buffer: String) {
        self.buffer = buffer.split(separator: "|").compactMap({ String.init($0) })
        self.currentPos = 0
    }
    
    fileprivate func readString() -> String {
        self.currentPos += 1
        let value = self.buffer[self.currentPos]
        self.currentPos += 1
        return value
    }
    
    func acquireType() throws -> ValueType {
        let raw: UInt8 = self.acquire()
        if let type = ValueType.init(rawValue: raw) {
            return type
        }
        throw BinaryDecoderError.typeNotExpected(value: raw)
    }
    
    func acquireIsArray() -> Bool {
        let value = self.buffer[self.currentPos] == "1"
        self.currentPos += 1
        return value
    }
    
    func acquireKey() -> String {
        return self.readString()
    }
    
    func acquireKeyCount() -> Int {
        return self.acquire()
    }
    
    func acquire() -> Int {
        let value = Int.init(self.buffer[self.currentPos])!
        self.currentPos += 1
        return value
    }
    
    func acquire() -> UInt {
        let value: Int = self.acquire()
        return UInt.init(value)
    }
    
    func acquire() -> Int8 {
        let value: Int = self.acquire()
        return Int8.init(value)
    }
    
    func acquire() -> UInt8 {
        let value: Int = self.acquire()
        return UInt8.init(value)
    }
    
    func acquire() -> Int16 {
        let value: Int = self.acquire()
        return Int16.init(value)
    }
    
    func acquire() -> UInt16 {
        let value: Int = self.acquire()
        return UInt16.init(value)
    }
    
    func acquire() -> Int32 {
        let value: Int = self.acquire()
        return Int32.init(value)
    }
    
    func acquire() -> UInt32 {
        let value: Int = self.acquire()
        return UInt32.init(value)
    }
    
    func acquire() -> Int64 {
        let value: Int = self.acquire()
        return Int64.init(value)
    }
    
    func acquire() -> UInt64 {
        let value: Int = self.acquire()
        return UInt64.init(value)
    }
    
    func acquire() -> String {
        return self.readString()
    }
    
    func acquire() -> Data {
        let string: String = self.readString()
        return string.data(using: .utf8)!
    }
    
    func acquire() -> Bool {
        let value = Bool.init(self.buffer[self.currentPos])!
        self.currentPos += 1
        return value
    }
    
    func acquire() -> Float {
        let value = Float.init(self.buffer[self.currentPos])!
        self.currentPos += 1
        return value
    }
    
    func acquire() -> Double {
        let value = Double.init(self.buffer[self.currentPos])!
        self.currentPos += 1
        return value
    }
    
    fileprivate func readArray() -> Array<Int> {
        let count: Int = self.acquire()
        return (0..<count).compactMap({ _ in self.acquire() })
    }
    
    fileprivate func readArray() -> Array<String> {
        let count: Int = self.acquire()
        return (0..<count).compactMap({ _ in self.readString() })
    }
    
    func acquire() -> Array<Int> {
        return self.readArray()
    }
    
    func acquire() -> Array<UInt> {
        return self.readArray().compactMap({ UInt.init($0) })
    }
    
    func acquire() -> Array<Int8> {
        return self.readArray().compactMap({ Int8.init($0) })
    }
    
    func acquire() -> Array<UInt8> {
        return self.readArray().compactMap({ UInt8.init($0) })
    }
    
    func acquire() -> Array<Int16> {
        return self.readArray().compactMap({ Int16.init($0) })
    }
    
    func acquire() -> Array<UInt16> {
        return self.readArray().compactMap({ UInt16.init($0) })
    }
    
    func acquire() -> Array<Int32> {
        return self.readArray().compactMap({ Int32.init($0) })
    }
    
    func acquire() -> Array<UInt32> {
        return self.readArray().compactMap({ UInt32.init($0) })
    }
    
    func acquire() -> Array<Int64> {
        return self.readArray().compactMap({ Int64.init($0) })
    }
    
    func acquire() -> Array<UInt64> {
        return self.readArray().compactMap({ UInt64.init($0) })
    }
    
    func acquire() -> Array<String> {
        return self.readArray()
    }
    
    func acquire() -> Array<Data> {
        let value: Array<String> = self.readArray()
        return value.compactMap({ $0.data(using: .utf8)! })
    }
    
    func acquire() -> Array<Bool> {
        let value: Array<Int> = self.readArray()
        return value.compactMap({ $0 == 1 })
    }
    
    func acquire() -> Array<Float> {
        let count: Int = self.acquire()
        return (0..<count).compactMap({ _ in self.acquire() })
    }
    
    func acquire() -> Array<Double> {
        let count: Int = self.acquire()
        return (0..<count).compactMap({ _ in self.acquire() })
    }
}
