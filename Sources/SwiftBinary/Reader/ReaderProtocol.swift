//
//  ReaderProtocol.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 29/05/19.
//

import Foundation

protocol ReaderProtocol: class {
    func acquire() -> ValueType
    func acquireIsArray() -> Bool
    
    func acquireKey() -> String
    func acquireKeyCount() -> Int
    
    func acquire() -> Int
    func acquire() -> UInt
    func acquire() -> Int8
    func acquire() -> UInt8
    func acquire() -> Int16
    func acquire() -> UInt16
    func acquire() -> Int32
    func acquire() -> UInt32
    func acquire() -> Int64
    func acquire() -> UInt64
    func acquire() -> String
    func acquire() -> Data
    func acquire() -> Bool
    func acquire() -> Float
    func acquire() -> Double
    
    func acquire() -> Array<Int>
    func acquire() -> Array<UInt>
    func acquire() -> Array<Int8>
    func acquire() -> Array<UInt8>
    func acquire() -> Array<Int16>
    func acquire() -> Array<UInt16>
    func acquire() -> Array<Int32>
    func acquire() -> Array<UInt32>
    func acquire() -> Array<Int64>
    func acquire() -> Array<UInt64>
    func acquire() -> Array<String>
    func acquire() -> Array<Data>
    func acquire() -> Array<Bool>
    func acquire() -> Array<Float>
    func acquire() -> Array<Double>
}
