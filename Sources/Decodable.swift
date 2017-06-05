//
// Created by Anderson Lucas C. Ramos on 09/04/17.
//

import Foundation

public protocol Decodable : class {
	func decode(data: Data) throws
	func decode(bytes: inout UnsafePointer<UInt8>) throws
}

public extension Decodable {
	public func readString(from bytes: inout UnsafePointer<UInt8>) -> String {
		let length = Int(bytes.withMemoryRebound(to: Int32.self, capacity: 1, { $0.pointee }))
		bytes = bytes.advanced(by: MemoryLayout<Int32>.size)
		let stringPointer = bytes.withMemoryRebound(to: UInt8.self, capacity: 1, { $0 })
		guard let string = String(data: Data(bytes: stringPointer, count: length), encoding: .utf8) else { return "" }
		bytes = bytes.advanced(by: length)
		return string
	}

	public func readData(from bytes: inout UnsafePointer<UInt8>) -> Data {
		let length = Int(bytes.withMemoryRebound(to: Int32.self, capacity: 1, { $0.pointee }))
		bytes = bytes.advanced(by: MemoryLayout<Int32>.size)
		let dataBuffer = UnsafeBufferPointer(start: bytes, count: length)
		let data = Data(buffer: dataBuffer)
		bytes = bytes.advanced(by: length)
		return data
	}

	public func readOther<T>(from bytes: inout UnsafePointer<UInt8>, advance: Bool? = nil) -> T {
		let value = bytes.withMemoryRebound(to: T.self, capacity: 1, { $0.pointee })
		if advance ?? true {
			bytes = bytes.advanced(by: MemoryLayout<T>.size)
		}
		return value
	}
}
