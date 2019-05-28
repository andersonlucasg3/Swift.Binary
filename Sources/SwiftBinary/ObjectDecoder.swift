//
// Created by Anderson Lucas C. Ramos on 08/04/17.
//

import Foundation

public class ObjectDecoder {
	public init() {
		
	}
	
	public func decode(fromData data: Data, intoObject instance: DecodableProtocol) throws {
		print("starting decoder")
		let object = try IvarObject()
		try object.decode(data: data)
		print("Data decoded")
		
		try self.mapObject(object, intoObject: instance)
	}
	
	func mapObject(_ object: IvarObject, intoObject instance: DecodableProtocol) throws {
		var mirror: Mirror? = Mirror(reflecting: instance)

		while mirror != nil {
			for child in mirror!.children {
				if let key = child.label, let value = object.value.filter({$0.name == key}).first {
					print("decoding key \(key) of value \(value)")
					if child.value is OptionalProtocol {
						let optionalValue = child.value as! OptionalProtocol
						if optionalValue.isDecodable() {
							try instance.manualMapCall(with: self, value: value as! IvarObject, for: instance.propertyRef(for: key))
						} else {
							self.populateProperty(with: value, intoObject: instance)
						}
					} else if child.value is DecodableProtocol {
						let pointer = instance.propertyRef(for: key) as! UnsafeMutablePointer<DecodableProtocol>
						try self.mapObject(value as! IvarObject, intoObject: pointer.pointee)
					} else {
						self.populateProperty(with: value, intoObject: instance)
					}
				}
			}

			mirror = mirror?.superclassMirror
		}
	}

	fileprivate func getValue<T>(from token: Token, of type: T.Type) -> T {
		return (token as! IvarToken<T>).value
	}

	fileprivate func setProperty<T>(for token: IvarToken<T>, intoObject instance: DecodableProtocol) {
		print("setting property of type \(T.self) for token \(token) into object \(instance)")
		let anyPointer = instance.propertyRef(for: token.name)
		// this check needs to be made because Int is always Int64
		if anyPointer is UnsafeMutablePointer<Int> {
			let pointer = anyPointer as! UnsafeMutablePointer<Int>
			pointer.pointee = Int(token.value as! Int64)
		} else if anyPointer is UnsafeMutablePointer<Array<Int>> {
			let pointer = anyPointer as! UnsafeMutablePointer<Array<Int>>
			pointer.pointee = (token.value as! Array<Int64>).map({Int($0)})
		} else if anyPointer is UnsafeMutablePointer<T?> {
			let pointer = anyPointer as! UnsafeMutablePointer<T?>
			pointer.pointee = token.value
		} else {
			let pointer = anyPointer as! UnsafeMutablePointer<T>
			pointer.pointee = token.value
		}
	}

	fileprivate func populateProperty(with value: Token, intoObject instance: DecodableProtocol) {
		switch value.type! {
		case .int8: self.setProperty(for: value as! IvarToken<Int8>, intoObject: instance); break
		case .int16: self.setProperty(for: value as! IvarToken<Int64>, intoObject: instance); break
		case .int32: self.setProperty(for: value as! IvarToken<Int32>, intoObject: instance); break
		case .int64: self.setProperty(for: value as! IvarToken<Int64>, intoObject: instance); break
		case .float: self.setProperty(for: value as! IvarToken<Float>, intoObject: instance); break
		case .double: self.setProperty(for: value as! IvarToken<Double>, intoObject: instance); break
		case .data: self.setProperty(for: value as! IvarToken<Data>, intoObject: instance); break
		case .string: self.setProperty(for: value as! IvarToken<String>, intoObject: instance); break
        case .bool: self.setProperty(for: value as! IvarToken<Bool>, intoObject: instance); break
		default:
			self.populateArrayProperty(with: value, intoObject: instance)
			break
		}
	}
	
	fileprivate func populateArrayProperty(with value: Token, intoObject instance: DecodableProtocol) {
		switch value.type! {
		case .arrayInt8: self.setProperty(for: value as! IvarArray<Int8>, intoObject: instance); break
		case .arrayInt16: self.setProperty(for: value as! IvarArray<Int16>, intoObject: instance); break
		case .arrayInt32: self.setProperty(for: value as! IvarArray<Int32>, intoObject: instance); break
		case .arrayInt64: self.setProperty(for: value as! IvarArray<Int64>, intoObject: instance); break
		case .arrayFloat: self.setProperty(for: value as! IvarArray<Float>, intoObject: instance); break
		case .arrayDouble: self.setProperty(for: value as! IvarArray<Double>, intoObject: instance); break
		case .arrayString: self.setProperty(for: value as! IvarArray<String>, intoObject: instance); break
        case .arrayBool: self.setProperty(for: value as! IvarArray<Bool>, intoObject: instance); break
		default: break
		}
	}

	#if os(iOS) || os(OSX)

	// MARK: iOS and Mac OS code
	
	public func decodeAny(fromData data: Data, intoObject instance: AnyObject) throws {
		let object = try IvarObject()
		try object.decode(data: data)

		try self.populateFields(ofObject: instance, withObject: object)
	}
	
	fileprivate func populateFields(ofObject obj: AnyObject, withObject object: IvarObject) throws {
		for field in object.value {
			if DataType.isFixedSize(type: field.type) {
				self.setFixedSize(value: field, intoObject: obj)
			} else if DataType.isSizeable(type: field.type) {
				if field.type == .string {
					self.populateIvarToken(value: field as! IvarToken<String>, intoObject: obj)
				} else {
					self.populateIvarToken(value: field as! IvarToken<Data>, intoObject: obj)
				}
			} else {
				if DataType.isArray(type: field.type) {
					try self.populateTokenArray(token: field, intoObject: obj)
				} else {
					guard let instance = try self.populateObject(value: field, withName: field.name, ofObject: obj) else { continue }
					self.setIvarValue(object: obj, name: field.name, value: instance)
				}
			}
		}
	}

	fileprivate func populateObject(value: Token, withName name: String, ofObject object: AnyObject) throws -> AnyObject? {
		guard let type = try self.findObjectType(forField: name, ofObject: object) else { return nil }
		let instance = type.init()
		try self.populateFields(ofObject: instance, withObject: value as! IvarObject)
		return instance
	}
	
	internal func parseGenericType(_ type: String, enclosing: String) -> String {
		let enclosingLength = enclosing.count + 1
		let typeLength = type.count - enclosingLength - 1
		return NSString(string: type).substring(with: NSRange(location: enclosingLength, length: typeLength))
	}
	
	fileprivate func findObjectType(forField field: String, ofObject object: AnyObject) throws -> NSObject.Type? {
		let children = Mirror(reflecting: object).children
		for child in children {
			if child.label == field {
				guard let childType = type(of: child.value) as? NSObject.Type else {
                    let typeString = String(reflecting: type(of: child.value))
					let classType = self.parseGenericType(typeString, enclosing: "Swift.Optional")
					guard let recovered = NSClassFromString(classType) else {
						throw NSError(domain: "You MUST extend your class from NSObject, we couldn't avoid that yet.", code: -1)
					}
					return recovered as? NSObject.Type
				}
				return childType
			}
		}
		return nil
	}
    
    fileprivate func cleanClassType(_ classType: String) -> String {
        return classType.replacingOccurrences(of: "Swift.", with: "")
                        .replacingOccurrences(of: "Foundation.", with: "")
    }
	
	fileprivate func findArrayType(forField field: String, ofObject object: AnyObject) throws -> Any.Type? {
		let children = Mirror(reflecting: object).children
		for child in children {
			if child.label == field {
				guard let childType = type(of: child.value) as? NSObject.Type else {
                    let typeString = String(reflecting: type(of: child.value))
					let classType = self.parseGenericType(typeString, enclosing: "Swift.Array")
					guard let recovered = NSClassFromString(classType) else {
						switch self.cleanClassType(classType) {
						case "Int": return Array<Int>.self
						case "Int8": return Array<Int8>.self
						case "Int16": return Array<Int16>.self
						case "Int32": return Array<Int32>.self
						case "Int64": return Array<Int64>.self
						case "Float": return Array<Float>.self
						case "Double": return Array<Double>.self
						case "String": return Array<String>.self
						case "Data": return Array<Data>.self
                        case "Bool": return Array<Bool>.self
						default:
							throw NSError(domain: "Unsupported array type \(classType). Unkown reason yet.", code: -1)
						}
					}
					return recovered as? NSObject.Type
				}
				return childType
			}
		}
		return nil
	}

	fileprivate func populateTokenArray(token: Token, intoObject object: AnyObject) throws {
		if token.type == .arrayInt8 {
			try self.populateArray(values: token as! IvarArray<Int8>, intoObject: object)
		} else if token.type == .arrayInt16 {
			try self.populateArray(values: token as! IvarArray<Int16>, intoObject: object)
		} else if token.type == .arrayInt32 {
			try self.populateArray(values: token as! IvarArray<Int32>, intoObject: object)
		} else if token.type == .arrayInt64 {
			try self.populateArray(values: token as! IvarArray<Int64>, intoObject: object)
		} else if token.type == .arrayFloat {
			try self.populateArray(values: token as! IvarArray<Float>, intoObject: object)
		} else if token.type == .arrayDouble {
			try self.populateArray(values: token as! IvarArray<Double>, intoObject: object)
		} else if token.type == .arrayString {
			try self.populateArray(values: token as! IvarArray<String>, intoObject: object)
		} else if token.type == .arrayData {
			try self.populateArray(values: token as! IvarArray<Data>, intoObject: object)
        } else if token.type == .arrayBool {
            try self.populateArray(values: token as! IvarArray<Bool>, intoObject: object)
		} else if token.type == .arrayObject {
			try self.populateArray(values: token as! IvarArray<IvarObject>, intoObject: object)
		} else {
			throw NSError(domain: "Unsupported array type \(String.init(describing: token.type))", code: -1)
		}
	}
	
	fileprivate func populateArray<T>(values: IvarArray<T>, intoObject object: AnyObject) throws {
		if T.self == IvarObject.self {
			var array = [AnyObject]()
			guard let type = try self.findArrayType(forField: values.name, ofObject: object) as? NSObject.Type else { return }
			for val in values.value as [AnyObject] {
				let instance = type.init()
				try self.populateFields(ofObject: instance, withObject: val as! IvarObject)
				array.append(instance)
			}
            self.setIvarValue(object: object, name: values.name, value: array)
		} else {
			let type = try self.findArrayType(forField: values.name, ofObject: object)
			if type == Array<Int>.self {
				let converted = (values.value as! Array<Int64>).map({ Int($0) })
				self.populateIvarToken(value: try IvarArray(name: values.name, value: converted), intoObject: object)
			} else {
				self.populateIvarToken(value: values, intoObject: object)
			}
		}
	}
	
	fileprivate func setFixedSize(value: Token, intoObject object: AnyObject) {
		switch value.type! {
		case .int8: self.populateIvarToken(value: value as! IvarToken<Int8>, intoObject: object); break
		case .int16: self.populateIvarToken(value: value as! IvarToken<Int16>, intoObject: object); break
		case .int32: self.populateIvarToken(value: value as! IvarToken<Int32>, intoObject: object); break
		case .int64: self.populateIvarToken(value: value as! IvarToken<Int64>, intoObject: object); break
		case .float: self.populateIvarToken(value: value as! IvarToken<Float>, intoObject: object); break
		case .double: self.populateIvarToken(value: value as! IvarToken<Double>, intoObject: object); break
        case .bool: self.populateIvarToken(value: value as! IvarToken<Bool>, intoObject: object); break
		default: break
		}
	}

	fileprivate func getAnyObject(value: Token) -> AnyObject? {
		switch value.type! {
		case .int8: return (value as! IvarToken<Int8>).value as AnyObject
		case .int16: return (value as! IvarToken<Int16>).value as AnyObject
		case .int32: return (value as! IvarToken<Int32>).value as AnyObject
		case .int64: return (value as! IvarToken<Int64>).value as AnyObject
		case .float: return (value as! IvarToken<Float>).value as AnyObject
		case .double: return (value as! IvarToken<Double>).value as AnyObject
		case .data: return (value as! IvarToken<Data>).value as AnyObject
		case .string: return (value as! IvarToken<String>).value as AnyObject
        case .bool: return (value as! IvarToken<Bool>).value as AnyObject
		default: return nil
		}
	}

	fileprivate func populateIvarToken<T>(value: IvarToken<T>, intoObject object: AnyObject) {
		object.setValue(value.value, forKey: value.name)
	}
	
	fileprivate func setIvarValue<T : AnyObject, V>(object: T, name: String, value: V) {
		self.getIvarReference(object: object, name: name).pointee = value
	}
	
	fileprivate func getIvarReference<T : AnyObject, V>(object: T, name: String) -> UnsafeMutablePointer<V> {
		let ivar = class_getInstanceVariable(T.self, name.withCString({$0}))
		let offset = ivar_getOffset(ivar!)
        var object = object
        let pointer = withUnsafeMutablePointer(to: &object, { (p: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<V> in
            let advanced = p.advanced(by: offset)
            return advanced.withMemoryRebound(to: V.self, capacity: 1, { $0 })
        })
//        let pointer = Unmanaged.passUnretained(object).toOpaque().advanced(by: offset)
        return pointer
	}
	
	#endif
}
