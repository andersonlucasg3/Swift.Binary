//
// Created by Anderson Lucas C. Ramos on 09/04/17.
//

import Foundation

internal protocol Encodable : class {
	func encode() throws -> Data
}

internal extension Encodable {
	internal func writeString(_ string: String, into data: inout Data) {
		var length = Int32(string.lengthOfBytes(using: .utf8))
		data.append(self.unsafeBytes(of: &length))

		data.append(string.withCString({ $0.withMemoryRebound(to: UInt8.self, capacity: Int(length), { $0 }) }), count: Int(length))
	}

	internal func writeData(_ dt: Data, into data: inout Data) {
		var length = Int32(dt.count)
		data.append(self.unsafeBytes(of: &length))
		data.append(dt)
	}

	internal func writeOther<T>(_ other: T, info data: inout Data) {
		var value = other
		data.append(self.unsafeBytes(of: &value))
	}

	internal func unsafeBytes<T>(of value: inout T) -> UnsafeBufferPointer<UInt8> {
		let size = MemoryLayout.size(ofValue: value)
		return withUnsafePointer(to: &value, {
			$0.withMemoryRebound(to: UInt8.self, capacity: size, {
				UnsafeBufferPointer(start: $0, count: size)
			})
		})
	}
}
