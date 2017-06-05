//
// Created by Anderson Lucas C. Ramos on 09/04/17.
//

import Foundation

public enum DataType: UInt8 {
	case object = 0,
	     int8 = 1,
	     int16 = 2,
	     int32 = 3,
	     int64 = 4,
	     float = 5,
	     double = 6,
	     string = 7,
	     data = 8
	
	// array types
	case arrayObject = 9,
		arrayInt8 = 10,
		arrayInt16 = 11,
		arrayInt32 = 12,
		arrayInt64 = 13,
		arrayFloat = 14,
		arrayDouble = 15,
		arrayString = 16,
		arrayData = 17

	public static func isFixedSize<T>(type: T.Type) -> Bool {
		return type == DataType.int8 ||
			type == DataType.int16 ||
			type == DataType.int32 ||
			type == DataType.int64 ||
			type == DataType.float ||
			type == DataType.double
	}
	
	public static func isFixedSize(type: DataType) -> Bool {
		return type == DataType.int8 ||
			type == DataType.int16 ||
			type == DataType.int32 ||
			type == DataType.int64 ||
			type == DataType.float ||
			type == DataType.double
	}

	public static func isSizeable<T>(type: T.Type) -> Bool {
		return type == DataType.string ||
			type == DataType.data
	}
	
	public static func isSizeable(type: DataType) -> Bool {
		return type == DataType.string ||
			type == DataType.data
	}

	public static func isArray(type: DataType) -> Bool {
		switch type {
		case .arrayObject, .arrayInt8,
		     .arrayInt16, .arrayInt32,
		     .arrayInt64, .arrayFloat,
		     .arrayDouble, .arrayString,
		     .arrayData:
			return true
		default:
			return false
		}
	}
	
	public func getIvarInstance() throws -> Decodable {
		switch self {
		case .object: return try IvarObject()
		case .int8: return try IvarToken<Int8>()
		case .int16: return try IvarToken<Int16>()
		case .int32: return try IvarToken<Int32>()
		case .int64: return try IvarToken<Int64>()
		case .float: return try IvarToken<Float>()
		case .double: return try IvarToken<Double>()
		case .string: return try IvarToken<String>()
		case .data: return try IvarToken<Data>()
			// array types
		case .arrayObject: return try IvarArray<IvarObject>()
		case .arrayInt8: return try IvarArray<Int8>()
		case .arrayInt16: return try IvarArray<Int16>()
		case .arrayInt32: return try IvarArray<Int32>()
		case .arrayInt64: return try IvarArray<Int64>()
		case .arrayFloat: return try IvarArray<Float>()
		case .arrayDouble: return try IvarArray<Double>()
		case .arrayString: return try IvarArray<String>()
		case .arrayData: return try IvarArray<Data>()
		}
	}
}

public func ==<T>(type: T.Type, dataType: DataType) -> Bool {
	return ((type == Int.self || type == Int64.self) && dataType == .int64) ||
		(type == Int8.self && dataType == .int8) ||
		(type == Int16.self && dataType == .int16) ||
		(type == Int32.self && dataType == .int32) ||
		(type == Float.self && dataType == .float) ||
		(type == Double.self && dataType == .double) ||
		((type == String.self || type == NSString.self) && dataType == .string) ||
		((type == Data.self || type == NSData.self) && dataType == .data)
}

public func ==<T>(dataType: DataType, type: T.Type) -> Bool {
	return type == dataType
}
