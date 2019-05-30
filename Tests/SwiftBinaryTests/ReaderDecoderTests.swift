import XCTest
@testable import SwiftBinary

private struct Complex: Codable {
    let string: String
    let int: Int
    let arrayInt: [Int]
}

private struct Complex2: Codable {
    let string: String
    let int: Int
    let data: Data?
    let arrayString: [String]
    let complex: Complex
}

class ReaderDecoderTests: XCTestCase {
    #if os(Linux)
    static let allTests = [
        ("testReader", testReader)
    ]
    #endif
    
    func testReader() throws {
        let writer = StringWriter.init()
        
        writer.insert(type: .bool, is: false)
        writer.insert(value: true)
        writer.insert(type: .bool, is: false)
        writer.insert(value: false)
        writer.insert(type: .int16, is: true)
        writer.insert(contentsOf: [1, 2, 3, 4, 5, 6])
        writer.insert(type: .string, is: false)
        writer.insert(value: "maluco doido")
        writer.insert(type: .string, is: false)
        writer.insert(value: "maluco doido 2")
        
        let reader = StringReader.init(buffer: writer.buffer)
        
        var type = try reader.acquireType()
        assert(type == .bool)
        assert(!reader.acquireIsArray())
        assert(reader.acquire() == true)
        type = try reader.acquireType()
        assert(type == .bool)
        assert(!reader.acquireIsArray())
        assert(reader.acquire() == false)
        type = try reader.acquireType()
        assert(type == .int16)
        assert(reader.acquireIsArray() == true)
        let intArray: [Int] = reader.acquire()
        assert(intArray == [1, 2, 3, 4, 5, 6])
        type = try reader.acquireType()
        assert(type == .string)
        assert(!reader.acquireIsArray())
        assert(reader.acquire() == "maluco doido")
        type = try reader.acquireType()
        assert(type == .string)
        assert(!reader.acquireIsArray())
        assert(reader.acquire() == "maluco doido 2")
    }
}
