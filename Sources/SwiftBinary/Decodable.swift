//
// Created by Anderson Lucas C. Ramos on 09/04/17.
//

import Foundation

public protocol Decodable : class {
	func decode(data: Data) throws
    func decode(bytes: inout UnsafeBufferPointer<UInt8>, totalSize: inout Int) throws
}

public extension Decodable {
    func advanced<T>(pointer: UnsafeBufferPointer<UInt8>, totalSize: inout Int, for type: T.Type) -> UnsafeBufferPointer<UInt8> {
        let layoutSize = MemoryLayout<T>.stride
        return self.advanced(pointer: pointer, totalSize: &totalSize, advanceValue: layoutSize, for: T.self)
    }
    
    func advanced<T>(pointer: UnsafeBufferPointer<UInt8>, totalSize: inout Int, advanceValue: Int, for type: T.Type) -> UnsafeBufferPointer<UInt8> {
        totalSize = totalSize - advanceValue * MemoryLayout<T>.stride
        return pointer.withUnsafeBytes { (pointer) -> UnsafeBufferPointer<UInt8> in
            let unsafePointer = pointer.baseAddress!.advanced(by: advanceValue).assumingMemoryBound(to: UInt8.self)
            return UnsafeBufferPointer<UInt8>.init(start: unsafePointer, count: totalSize)
        }
    }
    
    func readString(from bytes: inout UnsafeBufferPointer<UInt8>, totalSize: inout Int) -> String {
        let length = bytes.withUnsafeBytes({ $0.load(as: Int32.self) })
        bytes = self.advanced(pointer: bytes, totalSize: &totalSize, for: Int32.self)

        guard let string = String(data: Data.init(buffer: bytes), encoding: .utf8) else { return "" }
        bytes = self.advanced(pointer: bytes, totalSize: &totalSize, advanceValue: Int.init(length), for: UInt8.self)
		return string
	}

    func readData(from bytes: inout UnsafeBufferPointer<UInt8>, totalSize: inout Int) -> Data {
        let length = bytes.withMemoryRebound(to: Int32.self, { $0.baseAddress! }).pointee
        bytes = self.advanced(pointer: bytes, totalSize: &totalSize, for: Int32.self)
        
		let data = Data.init(buffer: bytes)
        bytes = self.advanced(pointer: bytes, totalSize: &totalSize, advanceValue: Int.init(length), for: UInt8.self)
		return data
	}

    func readOther<T>(from bytes: inout UnsafeBufferPointer<UInt8>, totalSize: inout Int, advance: Bool? = nil) -> T {
        let value = bytes.withUnsafeBytes({ $0.load(as: T.self) })
		if advance.value(true) {
            bytes = self.advanced(pointer: bytes, totalSize: &totalSize, for: T.self)
		}
		return value
	}
}
