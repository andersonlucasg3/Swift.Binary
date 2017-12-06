//
// Created by Anderson Lucas C. Ramos on 09/04/17.
//

import Foundation

public protocol Encodable : class {
	func encode() throws -> Data
}

public extension Encodable {
	public func writeString(_ string: String, into data: inout Data) {
        var length = Int32(string.lengthOfBytes(using: .utf8))
		data.append(self.unsafeBytes(of: &length))

        data.append(string.data(using: .utf8)!)
	}

	public func writeData(_ dt: Data, into data: inout Data) {
		var length = Int32(dt.count)
		data.append(self.unsafeBytes(of: &length))
		data.append(dt)
	}

	public func writeOther<T>(_ other: T, info data: inout Data) {
		var value = other
		data.append(self.unsafeBytes(of: &value))
	}

	public func unsafeBytes<T>(of value: inout T) -> UnsafeBufferPointer<UInt8> {
		let size = MemoryLayout.size(ofValue: value)
		return withUnsafePointer(to: &value, {
			$0.withMemoryRebound(to: UInt8.self, capacity: size, {
				UnsafeBufferPointer(start: $0, count: size)
			})
		})
	}
}
