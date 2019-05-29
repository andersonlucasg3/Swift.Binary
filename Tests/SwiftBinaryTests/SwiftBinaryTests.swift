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
        
        assert(Array<Int8>.self == .int8)
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
    
    func testEncoder() {
        let encoder = BinaryEncoder.init()
        let value = Complex.init(string: "value", int: 10, arrayInt: [1, 2, 3, 4, 5])
        do {
            _ = try encoder.encode(value)
        } catch let err as BinaryEncoderError {
            switch err {
            case .typeNotExpected(let type):
                assert(false, "Type not expected: \(type)")
            }
        } catch {
            assert(false, error.localizedDescription)
        }
    }
}

#endif
