//
//  Dictionary+AnyNotNil.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 15/06/2017.
//

import Foundation

public extension Dictionary where Key == String, Value == Any {
	public mutating func append(_ value: Any, for key: String) {
		let optionalValue = value as? OptionalProtocol
		if optionalValue.isSome() {
			self[key] = optionalValue.unwrap()
		} else {
			self[key] = value
		}
	}
}
