//
// Created by Anderson Lucas C. Ramos on 09/04/17.
//

import Foundation

public protocol Decodable : class {
	func decode(data: Data) throws
    func decode(bytes: inout UnsafePointer<UInt8>) throws
}

public extension Decodable {
    func advanced<T>(pointer: UnsafePointer<UInt8>, for type: T.Type, count: Int = 1) -> UnsafePointer<UInt8> {
        let advanceCount = MemoryLayout<T>.size * count
        return pointer.advanced(by: advanceCount)
    }
    
    func readString(from bytes: inout UnsafePointer<UInt8>) -> String {
        let length = bytes.withMemoryRebound(to: Int32.self, capacity: 1, { $0.pointee })
        bytes = self.advanced(pointer: bytes, for: Int32.self)

        let buffer = UnsafeBufferPointer.init(start: bytes, count: Int.init(length))
        let data = Data.init(buffer: buffer)
        guard let string = String(data: data, encoding: .utf8) else { return "" }
        bytes = self.advanced(pointer: bytes, for: UInt8.self, count: Int.init(length))
		return string
	}

    func readData(from bytes: inout UnsafePointer<UInt8>) -> Data {
        let length = bytes.withMemoryRebound(to: Int32.self, capacity: 1, { $0.pointee })
        bytes = self.advanced(pointer: bytes, for: Int32.self)
        
		let data = Data.init(buffer: UnsafeBufferPointer.init(start: bytes, count: Int.init(length)))
        bytes = self.advanced(pointer: bytes, for: UInt8.self, count: Int.init(length))
		return data
	}

    func readOther<T>(from bytes: inout UnsafePointer<UInt8>, advance: Bool? = nil) -> T {
        defer {
            if advance.value(true) {
                bytes = self.advanced(pointer: bytes, for: T.self)
            }
        }
        if T.self == UInt8.self {
            return bytes.pointee as! T
        }
        return bytes.withMemoryRebound(to: T.self, capacity: 1, { $0.pointee })
	}
}
