//
//  WriterProtocol.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 28/05/19.
//

import Foundation

protocol BufferedProtocol: class {
    associatedtype Buffer
    
    var buffer: Buffer { get }
}

protocol WriterProtocol: class {
    func insert(type: ValueType, is array: Bool)
    
    func insert(key: String)
    func insert(keyCount: Int)
    
    func insert(value: Int)
    func insert(value: UInt)
    func insert(value: Int8)
    func insert(value: UInt8)
    func insert(value: Int16)
    func insert(value: UInt16)
    func insert(value: Int32)
    func insert(value: UInt32)
    func insert(value: Int64)
    func insert(value: UInt64)
    func insert(value: Countable)
    func insert(value: Bool)
    func insert(value: Float)
    func insert(value: Double)
    
    func insert(contentsOf array: Array<Int>)
    func insert(contentsOf array: Array<UInt>)
    func insert(contentsOf array: Array<Int8>)
    func insert(contentsOf array: Array<UInt8>)
    func insert(contentsOf array: Array<Int16>)
    func insert(contentsOf array: Array<UInt16>)
    func insert(contentsOf array: Array<Int32>)
    func insert(contentsOf array: Array<UInt32>)
    func insert(contentsOf array: Array<Int64>)
    func insert(contentsOf array: Array<UInt64>)
    func insert<C : Countable>(contentsOf array: Array<C>)
    func insert(contentsOf array: Array<Bool>)
    func insert(contentsOf array: Array<Float>)
    func insert(contentsOf array: Array<Double>)
}
