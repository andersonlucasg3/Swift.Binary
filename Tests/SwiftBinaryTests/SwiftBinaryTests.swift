#if os(iOS) || os(OSX)

import XCTest
@testable import SwiftBinary

struct Complex: Codable {
    let string: String
    let int: Int
    let arrayInt: [Int]
}

struct ComplexArray: Codable {
    
}

//struct ComplexChild: Codable {
//
//}

class SwiftBinaryTests: XCTestCase {
    func testValueTypes() {
        assert(Int.self == ValueType.int64)
        assert(UInt.self == ValueType.int64)
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
    
    func testWriterPrimitiveValue() {
        let writer = StringWriter.init()
        
        writer.insert(type: .int64, is: false)
        writer.insert(key: "value")
        writer.insert(value: 10)
        
        let stringValue = "\(ValueType.int64.rawValue)0\("value".lengthOfBytes(using: .utf8))value10"
        assert(writer.buffer == stringValue)
    }
    
    func testWriterArrayPrimitiveValue() throws {
        let writer = StringWriter.init()
        
        writer.insert(type: .int64, is: true)
        writer.insert(key: "value")
        writer.insert(contentsOf: [1, 2, 3, 4, 5])
        
        let stringValue = "\(ValueType.int64.rawValue)\(1)\("value".lengthOfBytes(using: .utf8))value512345"
        
        assert(writer.buffer == stringValue)
    }
    
    func testEncoder() {
        let value = Complex.init(string: "legal", int: 10, arrayInt: [1, 2, 3, 4, 5])
        
        let encoder = BinaryEncoder.init()
        let writer = StringWriter.init()
        do {
            try encoder.encode(value, writer: writer)
        } catch let error as BinaryEncoderError {
            switch error {
            case .typeNotExpected(let type):
                assert(false, "Type not expected: \(type)")
            }
        } catch {
            assert(false, "Failure: \(error.localizedDescription)")
        }
        
        let testWriter = StringWriter.init()
        testWriter.insert(type: .object, is: false)
        testWriter.insert(value: Int32.init(0))
        testWriter.insert(keyCount: 3)
        testWriter.insert(type: .string, is: false)
        testWriter.insert(key: "string")
        testWriter.insert(value: "legal")
        testWriter.insert(type: .int64, is: false)
        testWriter.insert(key: "int")
        testWriter.insert(value: 10)
        testWriter.insert(type: .int64, is: true)
        testWriter.insert(key: "arrayInt")
        [1, 2, 3, 4, 5].forEach({ testWriter.insert(value: $0) })
        
        assert(writer.buffer == testWriter.buffer)
    }
}

extension BinaryEncoder {
    public func encode(_ value: Encodable, writer: WriterProtocol) throws {
        let enc = BinaryEnc.init(writer: writer, object: value)
        try value.encode(to: enc)
    }
}

#endif
