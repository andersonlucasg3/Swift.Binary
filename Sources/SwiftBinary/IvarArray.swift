//
// Created by Anderson Lucas C. Ramos on 11/04/17.
//

import Foundation

public class IvarArray<T> : IvarToken<Array<T>> {
	public override func findType() throws {
		let type = T.self
		if type is Int.Type || type is Int64.Type {
			self.type = .arrayInt64
		} else if type is Int8.Type {
			self.type = .arrayInt8
		} else if type is Int16.Type {
			self.type = .arrayInt16
		} else if type is Int32.Type {
			self.type = .arrayInt32
		} else if type is Float.Type {
			self.type = .arrayFloat
		} else if type is Double.Type {
			self.type = .arrayDouble
		} else if type is String.Type {
			self.type = .arrayString
		} else if type is Data.Type {
			self.type = .arrayData
        } else if type is Bool.Type {
            self.type = .arrayBool
		} else if type is IvarObject.Type {
			self.type = .arrayObject
		} else {
			throw NSError(domain: "Type [[[\(T.self)]]] not supported yet.", code: -1)
		}
	}

	// MARK: encoding implementations

	public override func encode() throws -> Data {
		var data = Data()
		self.writeOther(self.type.rawValue, info: &data)
		self.writeString(self.name, into: &data)
		try self.writeValue(into: &data)
		return data
	}

	public override func writeValue(into data: inout Data) throws {
		self.writeOther(Int32(self.value.count), info: &data)
		if DataType.isFixedSize(type: T.self) {
			for fixed in self.value {
				self.writeOther(fixed, info: &data)
			}
		} else if DataType.isSizeable(type: T.self) {
			for sizable in self.value {
				if sizable is String || sizable is NSString {
					self.writeString(sizable as! String, into: &data)
				} else {
					self.writeData(sizable as! Data, into: &data)
				}
			}
		} else {
			for token in self.value {
				data.append(try (token as! Token).encode())
			}
		}
	}

	// MARK: decoding implementations

	public override func decode(data: Data) throws {
		var bytes = data.withUnsafeBytes({ $0.bindMemory(to: UInt8.self) }).baseAddress!
		try self.decode(bytes: &bytes)
	}

    public override func decode(bytes: inout UnsafePointer<UInt8>) throws {
		self.type = DataType(rawValue: self.readOther(from: &bytes))
		self.name = self.readString(from: &bytes)
		try self.readValue(from: &bytes)
	}

    public override func readValue(from bytes: inout UnsafePointer<UInt8>) throws {
		let count = Int(self.readOther(from: &bytes) as Int32)

		self.value = self.getTypedArray() as! [T]
		if DataType.isFixedSize(type: T.self) {
			for _ in 0..<count {
				self.value.append(self.readOther(from: &bytes))
			}
		} else if DataType.isSizeable(type: T.self) {
			for _ in 0..<count {
				let type = DataType(rawValue: self.readOther(from: &bytes, advance: false))
				if type == .string {
					self.value.append(self.readString(from: &bytes) as! T)
				} else {
					self.value.append(self.readData(from: &bytes) as! T)
				}
			}
		} else {
			for _ in 0..<count {
				let type = DataType(rawValue: self.readOther(from: &bytes, advance: false))
				let decodable = try type!.getIvarInstance()
				try decodable.decode(bytes: &bytes)
				self.value.append(decodable as! T)
			}
		}
	}
	
	fileprivate func getTypedArray() -> [AnyObject] {
		switch self.type! {
		case .arrayInt8: return Array<IvarToken<Int8>>() as [AnyObject]
		case .arrayInt16: return Array<IvarToken<Int16>>() as [AnyObject]
		case .arrayInt32: return Array<IvarToken<Int32>>() as [AnyObject]
		case .arrayInt64: return Array<IvarToken<Int64>>() as [AnyObject]
		case .arrayFloat: return Array<IvarToken<Float>>() as [AnyObject]
		case .arrayDouble: return Array<IvarToken<Double>>() as [AnyObject]
		case .arrayString: return Array<IvarToken<String>>() as [AnyObject]
		case .arrayData: return Array<IvarToken<Data>>() as [AnyObject]
        case .arrayBool: return Array<IvarToken<Bool>>() as [AnyObject]
		default:
			return Array<AnyObject>()
		}
	}
}
