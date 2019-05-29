import XCTest
@testable import SwiftBinary

struct Complex: Codable {
    let string: String
    let int: Int
    let arrayInt: [Int]
}

struct Complex2: Codable {
    let string: String
    let int: Int
    let data: Data?
    let arrayString: [String]
    let complex: Complex
}

class SwiftBinaryTests: XCTestCase {
    #if os(Linux)
    static let allTests = [
        ("testValueTypes", testValueTypes),
        ("testTypeToValueTypeConversion", testTypeToValueTypeConversion),
        ("testWriterPrimitiveValue", testWriterPrimitiveValue),
        ("testWriterArrayPrimitiveValue", testWriterArrayPrimitiveValue),
        ("testEncoder", testEncoder),
        ("testComplexEncoder", testComplexEncoder),
        ("testEncodeRootArrayInt", testEncodeRootArrayInt),
        ("testEncodeRootArrayString", testEncodeRootArrayString),
        ("testEncodeRootArrayObject", testEncodeRootArrayObject),
        ("testPerformanceJson", testPerformanceJson),
        ("testPerformanceBinary", testPerformanceBinary)
    ]
    #endif
    
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
    
    func testEncoder() throws {
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
        
        self.beginObject(in: testWriter, isArray: false, keyCount: 3)
        try self.objectProperty(in: testWriter, key: "string", value: value.string)
        try self.objectProperty(in: testWriter, key: "int", value: value.int)
        try self.objectProperty(in: testWriter, key: "arrayInt", value: value.arrayInt)
        
        assert(writer.buffer == testWriter.buffer)
    }
    
    func testComplexEncoder() throws {
        let value = Complex2.init(string: "legal", int: 1, data: "cool".data(using: .utf8)!, arrayString: ["cool1", "cool2"], complex: Complex.init(string: "legal2", int: 2, arrayInt: [1, 2, 3, 4]))
        
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
        
        self.beginObject(in: testWriter, isArray: false, keyCount: 5)
        try self.objectProperty(in: testWriter, key: "string", value: value.string)
        try self.objectProperty(in: testWriter, key: "int", value: value.int)
        try self.objectProperty(in: testWriter, key: "data", value: value.data)
        try self.objectProperty(in: testWriter, key: "arrayString", values: value.arrayString)
        self.beginObject(in: testWriter, isArray: false, key: "complex", keyCount: 3)
        try self.objectProperty(in: testWriter, key: "string", value: value.complex.string)
        try self.objectProperty(in: testWriter, key: "int", value: value.complex.int)
        try self.objectProperty(in: testWriter, key: "arrayInt", values: value.complex.arrayInt)
        
        
        assert(writer.buffer == testWriter.buffer)
    }
    
    func testEncodeRootArrayInt() throws {
        let value = [1, 2, 3, 4, 5]
        
        let writer = StringWriter.init()
        
        let encoder = BinaryEncoder.init()
        try encoder.encode(value, writer: writer)
        
        let testWriter = StringWriter.init()
        
        try self.objectProperty(in: testWriter, key: "", values: value)
        
        assert(writer.buffer == testWriter.buffer)
    }
    
    func testEncodeRootArrayString() throws {
        let value = ["1", "2", "3", "4"]
        
        let writer = StringWriter.init()
        
        let encoder = BinaryEncoder.init()
        try encoder.encode(value, writer: writer)
        
        let testWriter = StringWriter.init()
        
        try self.objectProperty(in: testWriter, key: "", values: value)
        
        assert(writer.buffer == testWriter.buffer)
    }
    
    func testEncodeRootArrayObject() throws {
        let value = Complex.init(string: "legal2", int: 2, arrayInt: [1, 2, 3, 4])
        let values = [ value, value ]
        
        let writer = StringWriter.init()
        
        let encoder = BinaryEncoder.init()
        try encoder.encode(values, writer: writer)
        
        let testWriter = StringWriter.init()
        
        self.beginObject(in: testWriter, isArray: true, keyCount: 2)
        try (0..<2).forEach({ _ in
            self.beginObject(in: testWriter, isArray: false, keyCount: 3)
            try self.objectProperty(in: testWriter, key: "string", value: value.string)
            try self.objectProperty(in: testWriter, key: "int", value: value.int)
            try self.objectProperty(in: testWriter, key: "arrayInt", values: value.arrayInt)
        })
        
        assert(writer.buffer == testWriter.buffer)
    }
    
    func testPerformanceJson() {
        let value = Complex2.init(string: "legal", int: 1, data: "cool".data(using: .utf8)!, arrayString: ["cool1", "cool2"], complex: Complex.init(string: "legal2", int: 2, arrayInt: [1, 2, 3, 4]))
        let values = [
            value,
            value,
            value,
            value
        ]
        
        let encoder = JSONEncoder.init()
        self.measure {
            do {
                _ = try encoder.encode(values)
            } catch {
                assert(false)
            }
        }
    }
    
    func testPerformanceBinary() {
        let value = Complex2.init(string: "legal", int: 1, data: "cool".data(using: .utf8)!, arrayString: ["cool1", "cool2"], complex: Complex.init(string: "legal2", int: 2, arrayInt: [1, 2, 3, 4]))
        let values = [
            value,
            value,
            value,
            value
        ]
        
        let encoder = BinaryEncoder.init()
        self.measure {
            do {
                _ = try encoder.encode(values)
            } catch {
                assert(false, error.localizedDescription)
            }
        }
    }
    
    // MARK: - Writer helpers
    
    fileprivate func beginObject(in writer: WriterProtocol, isArray: Bool, key: String = "", keyCount: Int) {
        writer.insert(type: .object, is: isArray)
        writer.insert(key: key)
        writer.insert(keyCount: keyCount)
    }
    
    fileprivate func objectProperty<T>(in writer: WriterProtocol, key: String, value: T) throws where T: Encodable {
        let processor = EncodeTypeProcessor.init(writer: writer)
        try processor.write(value: value, key: key)
    }
    
    fileprivate func objectProperty<T>(in writer: WriterProtocol, key: String, values: [T]) throws where T: Encodable {
        let processor = EncodeTypeProcessor.init(writer: writer)
        writer.insert(type: try ValueType.from(type: T.self), is: true)
        writer.insert(key: key)
        try processor.write(value: values)
    }
}

extension BinaryEncoder {
    public func encode(_ value: Encodable, writer: WriterProtocol) throws {
        let enc = BinaryEnc.init(writer: writer, object: value)
        try value.encode(to: enc)
    }
}
