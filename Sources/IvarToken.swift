//
// Created by Anderson Lucas C. Ramos on 09/04/17.
//

import Foundation

public class IvarToken<T>: Token {
    private var tokenValue: T!
    
    public internal(set) var value: T {
        get { return self.tokenValue! }
        
        set { self.tokenValue = newValue }
    }

	public override init() throws {
		try super.init()
		try self.findType()
		self.name = ""
	}

	public init(name: String, value: T) throws {
		try super.init()
		try self.findType()
		self.name = name
		self.value = value
	}

	public func findType() throws {
		let type = T.self
		if type is Int.Type || type is Int64.Type {
			self.type = .int64
		} else if type is Int8.Type {
			self.type = .int8
		} else if type is Int16.Type {
			self.type = .int16
		} else if type is Int32.Type {
			self.type = .int32
		} else if type is Float.Type {
			self.type = .float
		} else if type is Double.Type {
			self.type = .double
		} else if type is String.Type {
			self.type = .string
		} else if type is Data.Type {
			self.type = .data
		} else {
			throw NSError(domain: "Type [[[\(T.self)]]] not supported yet.", code: -1)
		}
	}

	// MARK: Encoding implementations

	public override func encode() throws -> Data {
		var data = Data()
		self.writeOther(self.type.rawValue, info: &data)
		self.writeString(self.name, into: &data)
		try self.writeValue(into: &data)
		return data
	}

	public func writeValue(into data: inout Data) throws {
		switch self.type {
		case .string: self.writeString(self.value as! String, into: &data); break
		case .data: self.writeData(self.value as! Data, into: &data); break
		default: self.writeOther(self.value, info: &data); break
		}
	}

	// Decoding implementations

	public override func decode(data: Data) throws {
		var bytes = data.withUnsafeBytes({ $0 as UnsafePointer<UInt8> })
		try self.decode(bytes: &bytes)
	}

	public override func decode(bytes: inout UnsafePointer<UInt8>) throws {
		self.type = DataType(rawValue: self.readOther(from: &bytes))
		self.name = self.readString(from: &bytes)
		try self.readValue(from: &bytes)
	}

	public func readValue(from bytes: inout UnsafePointer<UInt8>) throws {
		switch self.type {
		case .string: self.value = self.readString(from: &bytes) as! T; break
		case .data: self.value = self.readData(from: &bytes) as! T; break
		default: self.value = self.readOther(from: &bytes); break
		}
	}
}
