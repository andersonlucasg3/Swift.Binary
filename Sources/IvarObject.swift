//
// Created by Anderson Lucas C. Ramos on 11/04/17.
//

import Foundation

internal class IvarObject: IvarToken<Array<Token>> {
	internal override func findType() {
		self.type = .object
	}

	// MARK: encoding implementations

	internal override func encode() throws -> Data {
		var data = Data()
		self.writeOther(self.type.rawValue, info: &data)
		self.writeString(self.name, into: &data)
		try self.writeValue(into: &data)
		return data
	}

	internal override func writeValue(into data: inout Data) throws {
		self.writeOther(Int32(self.value.count), info: &data)
		for token in self.value {
			data.append(try token.encode())
		}
	}

	// MARK: decoding implementations

	internal override func decode(data: Data) throws {
		var bytes = data.withUnsafeBytes({ $0 as UnsafePointer<UInt8> })
		try self.decode(bytes: &bytes)
	}

	internal override func decode(bytes: inout UnsafePointer<UInt8>) throws {
		self.type = DataType(rawValue: self.readOther(from: &bytes))
		self.name = self.readString(from: &bytes)
		try self.readValue(from: &bytes)
	}

	internal override func readValue(from bytes: inout UnsafePointer<UInt8>) throws {
		let count = Int(self.readOther(from: &bytes) as Int32)
		
		self.value = Array<Token>()
		for _ in 0..<count {
			let type = DataType(rawValue: self.readOther(from: &bytes, advance: false))
			let decodable = try type!.getIvarInstance()
			try decodable.decode(bytes: &bytes)
			self.value.append(decodable as! Token)
		}
	}
}
