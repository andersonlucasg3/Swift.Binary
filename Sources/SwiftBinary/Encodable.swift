//
// Created by Anderson Lucas C. Ramos on 09/04/17.
//

import Foundation

public protocol Encodable : class {
	func encode() throws -> Data
}

public extension Encodable {
	func writeString(_ string: String, into data: inout Data) {
        var length = Int32(string.lengthOfBytes(using: .utf8))
		data.append(self.unsafeBytes(of: &length))

        data.append(string.data(using: .utf8)!)
	}

	func writeData(_ dt: Data, into data: inout Data) {
		var length = Int32(dt.count)
		data.append(self.unsafeBytes(of: &length))
		data.append(dt)
	}

	func writeOther<T>(_ other: T, info data: inout Data) {
		var value = other
		data.append(self.unsafeBytes(of: &value))
	}

	func unsafeBytes<T>(of value: inout T) -> UnsafeBufferPointer<UInt8> {
        return withUnsafeBytes(of: &value, {
            return $0.bindMemory(to: UInt8.self)
        })
	}
}
