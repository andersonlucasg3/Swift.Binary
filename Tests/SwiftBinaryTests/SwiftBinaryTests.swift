#if os(iOS) || os(OSX)

import XCTest
@testable import SwiftBinary

struct Complex: Codable {
    let string: String
    let int: Int
    let arrayInt: [Int]
    
    private enum CodingKeys: String, CodingKey {
        case string
        case int
        case arrayInt
    }
}

//struct ComplexChild: Codable {
//
//}

class SwiftBinaryTests: XCTestCase {
    func testValueTypes() {
        assert(Int.self == ValueType.int)
        assert(Int8.self == ValueType.int8)
        assert(UInt8.self == ValueType.int8)
        
        assert(Int16.self == ValueType.int16)
        assert(UInt16.self == ValueType.int16)
        
        assert(Int32.self == ValueType.int32)
        assert(UInt32.self == ValueType.int32)
        
        assert(Int64.self == ValueType.int64)
        assert(UInt64.self == ValueType.int64)
        
        assert(Float.self == ValueType.float)
        assert(Double.self == ValueType.double)
        assert(Bool.self == ValueType.bool)
        assert(String.self == ValueType.string)
        assert(Data.self == ValueType.data)
        assert(Complex.self == ValueType.object)
        
//        assert(Array<Int>.self == .arrayInt)
//        assert(Array<Int8>.self == .arrayInt8)
//        assert(Array<Int16>.self == .arrayInt16)
//        assert(Array<Int32>.self == .arrayInt32)
//        assert(Array<Int64>.self == .arrayInt64)
//        assert(Array<Bool>.self == .arrayBool)
//        assert(Array<Float>.self == .arrayFloat)
//        assert(Array<Double>.self == .arrayDouble)
//        assert(Array<String>.self == .arrayString)
//        assert(Array<Data>.self == .arrayData)
//        assert(Array<Complex>.self == .arrayObject)
    }
    
    func testTypeToValueTypeConversion() {
        do {
            let isInt8 = try ValueType.from(type: Int8.self) == .int8
            let isUInt8 = try ValueType.from(type: UInt8.self) == .int8
            
            let isInt16 = try ValueType.from(type: Int16.self) == .int16
            let isUInt16 = try ValueType.from(type: UInt16.self) == .int16
            
            let isInt32 = try ValueType.from(type: Int32.self) == .int32
            let isUInt32 = try ValueType.from(type: UInt32.self) == .int32
            
            let isInt64 = try ValueType.from(type: Int64.self) == .int64
            let isUInt64 = try ValueType.from(type: UInt64.self) == .int64
            
            let isFloat = try ValueType.from(type: Float.self) == .float
            let isDouble = try ValueType.from(type: Double.self) == .double
            let isBool = try ValueType.from(type: Bool.self) == .bool
            let isString = try ValueType.from(type: String.self) == .string
            let isData = try ValueType.from(type: Data.self) == .data
            
            let isObject = try ValueType.from(type: Complex.self) == .object
            
            assert(isInt8)
            assert(isUInt8)
            
            assert(isInt16)
            assert(isUInt16)
            
            assert(isInt32)
            assert(isUInt32)
            
            assert(isInt64)
            assert(isUInt64)
            
            assert(isFloat)
            assert(isDouble)
            assert(isBool)
            assert(isString)
            assert(isData)
            assert(isObject)
        } catch {
            assert(false, error.localizedDescription)
        }
    }
    
    func testWriterPrimitiveValue() throws {
        let writer = StringWriter.init()
        
        try writer.insert(type: .int, is: false)
        try writer.insert(key: "value")
        try writer.insert(value: 10)
        
        let stringValue = """
        type: \(0) |
        array: \(0) |
        key length: \("value".lengthOfBytes(using: .utf8)) |
        key content: value |
        value: \(10) |
        """
        assert(writer.buffer == stringValue)
    }
    
    func testWriterArrayPrimitiveValue() throws {
        let writer = StringWriter.init()
        
        try writer.insert(type: .int, is: true)
        try writer.insert(key: "value")
        try writer.insert(contentsOf: [1, 2, 3, 4, 5])
        
        let stringValue = """
        type: \(0) |
        array: \(1) |
        key length: \("value".lengthOfBytes(using: .utf8)) |
        key content: \("value") |
        array count: \(5) |
        value: \(1) |value: \(2) |value: \(3) |value: \(4) |value: \(5) |
        """
        
        assert(writer.buffer == stringValue)
    }
}

#endif
