//
//  WriterProtocol.swift
//  SwiftBinary
//
//  Created by Anderson Lucas de Castro Ramos on 28/05/19.
//

import Foundation

protocol WriterProtocol: class {
    associatedtype Buffer
    
    var buffer: Buffer { get }
    
    func insert(type: ValueType, is array: Bool) throws
    
    func insert(key: String) throws
    
    func insert(value: Int) throws
    func insert(value: UInt) throws
    func insert(value: Int8) throws
    func insert(value: UInt8) throws
    func insert(value: Int16) throws
    func insert(value: UInt16) throws
    func insert(value: Int32) throws
    func insert(value: UInt32) throws
    func insert(value: Int64) throws
    func insert(value: UInt64) throws
    func insert(value: Countable) throws
    func insert(value: Bool) throws
    func insert(value: Float) throws
    func insert(value: Double) throws
    
    func insert(contentsOf array: Array<Int>) throws
    func insert(contentsOf array: Array<UInt>) throws
    func insert(contentsOf array: Array<Int8>) throws
    func insert(contentsOf array: Array<UInt8>) throws
    func insert(contentsOf array: Array<Int16>) throws
    func insert(contentsOf array: Array<UInt16>) throws
    func insert(contentsOf array: Array<Int32>) throws
    func insert(contentsOf array: Array<UInt32>) throws
    func insert(contentsOf array: Array<Int64>) throws
    func insert(contentsOf array: Array<UInt64>) throws
    func insert<C : Countable>(contentsOf array: Array<C>) throws
    func insert(contentsOf array: Array<Bool>) throws
    func insert(contentsOf array: Array<Float>) throws
    func insert(contentsOf array: Array<Double>) throws
}
