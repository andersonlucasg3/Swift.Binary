//
//  DataReader.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 29/05/19.
//

import Foundation

class DataReader: ReaderProtocol, BufferedProtocol {
    typealias Buffer = UnsafePointer<UInt8>
    
    fileprivate(set) var buffer: Buffer
    
    init(data: Data) {
        self.buffer = data.withUnsafeBytes({ $0.bindMemory(to: UInt8.self) }).baseAddress!
    }
    
    fileprivate func advance(count: Int) {
        self.buffer = self.buffer.advanced(by: count)
    }
    
    fileprivate func read<T: Encodable>() -> T {
        let size = MemoryLayout<T>.size
        let ret = self.buffer.withMemoryRebound(to: T.self, capacity: 1, { $0.pointee })
        self.advance(count: size)
        return ret
    }
    
    fileprivate func read<T: Countable>(type: T.Type = T.self) -> T {
        let length: Int32 = self.read()
        let value = T.init(pointer: self.buffer, length: length)
        self.advance(count: Int.init(length))
        return value
    }
    
    fileprivate func readArray<T: Encodable>() -> Array<T> {
        let count: Int32 = self.read()
        return (0..<count).compactMap({ _ in self.read() })
    }
    
    func acquireType() throws -> ValueType {
        let raw: UInt8 = self.read()
        if let type = ValueType.init(rawValue: raw) {
            return type
        }
        throw BinaryDecoderError.typeNotExpected(value: raw)
    }
    
    func acquireIsArray() -> Bool {
        return self.read()
    }
    
    func acquireKey() -> String {
        return self.read(type: String.self)
    }
    
    func acquireKeyCount() -> Int {
        let count: Int16 = self.read()
        return Int.init(count)
    }
    
    func acquire() -> Int {
        let value: Int64 = self.read()
        return Int.init(value)
    }
    
    func acquire() -> UInt {
        let value: UInt64 = self.read()
        return UInt.init(value)
    }
    
    func acquire() -> Int8 {
        return self.read()
    }
    
    func acquire() -> UInt8 {
        return self.read()
    }
    
    func acquire() -> Int16 {
        return self.read()
    }
    
    func acquire() -> UInt16 {
        return self.read()
    }
    
    func acquire() -> Int32 {
        return self.read()
    }
    
    func acquire() -> UInt32 {
        return self.read()
    }
    
    func acquire() -> Int64 {
        return self.read()
    }
    
    func acquire() -> UInt64 {
        return self.read()
    }
    
    func acquire() -> String {
        return self.read(type: String.self)
    }
    
    func acquire() -> Data {
        return self.read(type: Data.self)
    }
    
    func acquire() -> Bool {
        return self.read()
    }
    
    func acquire() -> Float {
        return self.read()
    }
    
    func acquire() -> Double {
        return self.read()
    }
    
    func acquire() -> Array<Int> {
        let values: Array<Int64> = self.readArray()
        return values.compactMap({ Int.init($0) })
    }
    
    func acquire() -> Array<UInt> {
        let values: Array<UInt64> = self.readArray()
        return values.compactMap({ UInt.init($0) })
    }
    
    func acquire() -> Array<Int8> {
        return self.readArray()
    }
    
    func acquire() -> Array<UInt8> {
        return self.readArray()
    }
    
    func acquire() -> Array<Int16> {
        return self.readArray()
    }
    
    func acquire() -> Array<UInt16> {
        return self.readArray()
    }
    
    func acquire() -> Array<Int32> {
        return self.readArray()
    }
    
    func acquire() -> Array<UInt32> {
        return self.readArray()
    }
    
    func acquire() -> Array<Int64> {
        return self.readArray()
    }
    
    func acquire() -> Array<UInt64> {
        return self.readArray()
    }
    
    func acquire() -> Array<String> {
        return self.readArray()
    }
    
    func acquire() -> Array<Data> {
        return self.readArray()
    }
    
    func acquire() -> Array<Bool> {
        return self.readArray()
    }
    
    func acquire() -> Array<Float> {
        return self.readArray()
    }
    
    func acquire() -> Array<Double> {
        return self.readArray()
    }
}
