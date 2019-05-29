//
//  Types.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

enum ValueType: UInt8 {
    case int = 0
    case int8
    case int16
    case int32
    case int64
    case float
    case double
    case bool
    case string
    case data
    case object
    
    // array types
    case arrayInt
    case arrayInt8
    case arrayInt16
    case arrayInt32
    case arrayInt64
    case arrayFloat
    case arrayDouble
    case arrayBool
    case arrayString
    case arrayData
    case arrayObject
    
    static func from<T>(type: T.Type = T.self) throws -> ValueType {
        if type == Int.self {
            return .int
        } else if type == Int8.self || type == UInt8.self {
            return .int8
        } else if type == Int16.self || type == UInt16.self {
            return .int16
        } else if type == Int32.self || type == UInt32.self {
            return .int32
        } else if type == Int64.self || type == UInt64.self {
            return .int64
        } else if type == Float.self {
            return .float
        } else if type == Double.self {
            return .double
        } else if type == Bool.self {
            return .bool
        } else if type == String.self {
            return .string
        } else if type == Data.self {
            return .data
        } else if let _ = type as? Codable.Type {
            return .object
        }
        throw BinaryEncoderError.typeNotExpected(type: type)
    }
}

func ==<T>(lhs: T.Type, rhs: ValueType) -> Bool {
    switch rhs {
    case .int: return lhs == Int.self
    case .int8: return lhs == Int8.self || lhs == UInt8.self
    case .int16: return lhs == Int16.self || lhs == UInt16.self
    case .int32: return lhs == Int32.self || lhs == UInt32.self
    case .int64: return lhs == Int64.self || lhs == UInt64.self
    case .float: return lhs == Float.self
    case .double: return lhs == Double.self
    case .bool: return lhs == Bool.self
    case .string: return lhs == String.self
    case .data: return lhs == Data.self
    case .arrayInt: return lhs == Array<Int>.self
    case .arrayInt8: return lhs == Array<Int8>.self || lhs == Array<UInt8>.self
    case .arrayInt16: return lhs == Array<Int16>.self || lhs == Array<UInt16>.self
    case .arrayInt32: return lhs == Array<Int32>.self || lhs == Array<UInt32>.self
    case .arrayInt64: return lhs == Array<Int64>.self || lhs == Array<UInt64>.self
    case .arrayFloat: return lhs == Array<Float>.self
    case .arrayDouble: return lhs == Array<Double>.self
    case .arrayBool: return lhs == Array<Bool>.self
    case .arrayString: return lhs == Array<String>.self
    case .arrayData: return lhs == Array<Data>.self
    case .arrayObject: return (Array<T>.Element.self as? Codable.Type) != nil
    case .object: return (lhs as? Codable.Type) != nil
    }
}
