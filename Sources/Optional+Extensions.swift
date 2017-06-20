//
//  OptionalProtocol.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 10/06/2017.
//
//

import Foundation

public protocol OptionalProtocol {
	func isSome() -> Bool
	func unwrap() -> Any
	func wrappedType() -> Any.Type
	func isDecodable() -> Bool
}

extension Optional : OptionalProtocol {
	public func isSome() -> Bool {
		switch self {
		case .none: return false
		case .some(_): return true
		}
	}
	
	public func unwrap() -> Any {
		switch self {
		// If a nil is unwrapped it will crash!
		case .none: preconditionFailure("nill unwrap")
		case .some(let unwrapped): return unwrapped
		}
	}
	
	public func wrappedType() -> Any.Type {
		return Wrapped.self
	}
	
	public func isDecodable() -> Bool {
		return Wrapped.self is DecodableProtocol.Type
	}
}
