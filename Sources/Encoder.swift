//
// Created by Anderson Lucas C. Ramos on 17/04/17.
//

import Foundation

public class Encoder {
	public init() {
		
	}

	public func encode(object: EncodableProtocol) throws -> Data {
		print("encode: \(object)")
		let ivarObject = try self.convert(object: object)
		return try ivarObject.encode()
	}

	fileprivate func convert(object: EncodableProtocol, forKey key: String = "") throws -> IvarObject {
		print("converting \(object) for key \(key)")
		var tokens = Array<Token>()

		let dict = object.mapObject()
		for (key, value) in dict {
			if value is EncodableProtocol {
				print("founda a encodableProtocol")
				tokens.append(try self.convert(object: value as! EncodableProtocol, forKey: key))
			} else {
				print("found a value of type \(type(of: value))")
				tokens.append(try self.getType(forValue: value, andKey: key))
			}
		}
		return try IvarObject(name: key, value: tokens)
	}

	fileprivate func encodeObject(ofObject obj: AnyObject, forKey key: String? = nil) throws -> IvarObject {
		#if os(iOS) || os(OSX)
		if obj is EncodableProtocol {
			return try self.convert(object: obj as! EncodableProtocol, forKey: key ?? "")
		}
		return try self.encodeObjectByMirror(ofObject:obj, forKey:key)
		#else
		return try self.convert(object: obj as! EncodableProtocol, forKey: key ?? "")
		#endif
	}

	#if os(iOS) || os(OSX)
	
	// MARK: iOS and Mac OS code
	
	public func encodeAny(object: AnyObject) throws -> Data {
		let object = try self.encodeObject(ofObject: object)
		return try object.encode()
	}

	fileprivate func encodeObjectByMirror(ofObject obj: AnyObject, forKey key: String? = nil) throws -> IvarObject {
		var tokens = Array<Token>()

		var cls: Mirror? = Mirror(reflecting: obj)
		
		if cls?.displayStyle != .class {
			throw NSError(domain: "Unsupported type for mirroring \(type(of: obj))", code: -1)
		}
		
		while cls != nil {
			for child in cls!.children {
				let key = child.label!
				let value = child.value

				tokens.append(try self.getType(forValue: value, andKey: key))
			}
			cls = cls?.superclassMirror
		}

		return try! IvarObject(name: key ?? "", value: tokens)
	}
	
	#endif

	fileprivate func getType(forValue value: Any, andKey key: String) throws -> Token {
		if value is String || value is NSString {
			return try self.getAnyType(forValue: value as! String, andKey: key)
		} else if value is Data || value is NSData {
			return try self.getAnyType(forValue: value as! Data, andKey: key)
		} else if value is Int8 {
			return try self.getAnyType(forValue: value as! Int8, andKey: key)
		} else if value is Int16 {
			return try self.getAnyType(forValue: value as! Int16, andKey: key)
		} else if value is Int32 {
			return try self.getAnyType(forValue: value as! Int32, andKey: key)
		} else if value is Int64 {
			return try self.getAnyType(forValue: value as! Int64, andKey: key)
		} else if value is Int {
			return try self.getAnyType(forValue: Int64(value as! Int), andKey: key)
		} else if value is Float {
			return try self.getAnyType(forValue: value as! Float, andKey: key)
		} else if value is Double {
			return try self.getAnyType(forValue: value as! Double, andKey: key)
		} else {
			return try self.getAnyType(forValue: value, andKey: key)
		}
	}

	fileprivate func getAnyType<T>(forValue value: T, andKey key: String) throws -> Token {
		if let token = try! self.getToken(ofValue: value, forKey: key) {
			return token
		} else {
			let mirror = Mirror(reflecting: value)
			let type = mirror.subjectType
			let typeInfo = self.parseTypeString("\(type)")

			if typeInfo.isArray {
				return try self.getArray(ofValues: value as! [Any], forKey: key)
			} else {
				#if os(Linux)
				return try self.encodeObject(ofObject: value as! AnyObject, forKey: key)
				#else
				return try self.encodeObject(ofObject: value as AnyObject, forKey: key)
				#endif
			}
		}
	}

	fileprivate func getArray(ofValues values: [Any], forKey key: String) throws -> Token {
		if values.count > 0 {
			let value = values[0]
			if value is String || value is NSString {
				return try self.getAnyArray(ofValues: values as! [String], forKey: key) as IvarArray<String>
			} else if value is Data || value is NSData {
				return try self.getAnyArray(ofValues: values as! [Data], forKey: key) as IvarArray<Data>
			} else if value is Int {
				return try self.getAnyArray(ofValues: values as! [Int], forKey: key) as IvarArray<Int>
			} else if value is Int8 {
				return try self.getAnyArray(ofValues: values as! [Int8], forKey: key) as IvarArray<Int8>
			} else if value is Int16 {
				return try self.getAnyArray(ofValues: values as! [Int16], forKey: key) as IvarArray<Int16>
			} else if value is Int32 {
				return try self.getAnyArray(ofValues: values as! [Int32], forKey: key) as IvarArray<Int32>
			} else if value is Int64 {
				return try self.getAnyArray(ofValues: values as! [Int64], forKey: key) as IvarArray<Int64>
			} else if value is Float {
				return try self.getAnyArray(ofValues: values as! [Float], forKey: key) as IvarArray<Float>
			} else if value is Double {
				return try self.getAnyArray(ofValues: values as! [Double], forKey: key) as IvarArray<Double>
			} else {
				print("Se estiver quebrando aqui esta muito errado!")
				var array = Array<IvarObject>()
				for val in values {
					#if os(Linux)
					array.append(try self.encodeObject(ofObject: val as! AnyObject))
					#else
					array.append(try self.encodeObject(ofObject: val as AnyObject))
					#endif
				}
				return try IvarArray(name: key, value: array)
			}
		}
		return try IvarArray<Int8>(name: key, value: Array<Int8>())
	}
	
	fileprivate func getAnyArray<T>(ofValues values: [Any], forKey key: String) throws -> IvarArray<T> {
		var tokens = Array<T>()
		for val in values {
			tokens.append(val as! T)
		}
		return try IvarArray(name: key, value: tokens)
	}

	fileprivate func getToken<T>(ofValue value: T, forKey key: String) throws -> Token? {
		if value is String || value is NSString {
			return try IvarToken(name: key, value: value as! String)
		} else if value is Data || value is NSData {
			return try IvarToken(name: key, value: value as! Data)
		} else if value is Int {
			return try IvarToken(name: key, value: Int64(value as! Int))
		} else if value is Int8 {
			return try IvarToken(name: key, value: value as! Int8)
		} else if value is Int16 {
			return try IvarToken(name: key, value: value as! Int16)
		} else if value is Int32 {
			return try IvarToken(name: key, value: value as! Int32)
		} else if value is Int64 {
			return try IvarToken(name: key, value: value as! Int64)
		} else if value is Float {
			return try IvarToken(name: key, value: value as! Float)
		} else if value is Double {
			return try IvarToken(name: key, value: value as! Double)
		}
		return nil
	}

	fileprivate func parseGenericType(_ type: String, enclosing: String) -> String {
		let enclosingLength = enclosing.lengthOfBytes(using: .utf8) + 1
		let typeLength = type.lengthOfBytes(using: .utf8) - enclosingLength - 1
		return NSString(string: type).substring(with: NSRange(location: enclosingLength, length: typeLength))
	}

	fileprivate func parseTypeString(_ type: String) -> (typeName: String, isOptional: Bool, isArray: Bool) {
		var isArray = false
		var isOptional = false

		var typeString = type
		if type.contains("Optional") {
			isOptional = true
			typeString = self.parseGenericType(type, enclosing: "Optional")
		}

		if typeString.contains("Array") {
			isArray = true
			typeString = self.parseGenericType(typeString, enclosing: "Array")
		}

		return (typeName: typeString, isOptional: isOptional, isArray: isArray)
	}
}
