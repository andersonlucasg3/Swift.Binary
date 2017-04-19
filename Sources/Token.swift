//
//  Token.swift
//  SwiftServer
//
//  Created by Anderson Lucas C. Ramos on 11/04/17.
//
//

import Foundation

internal class Token: Encodable, Decodable {
	internal(set) var type: DataType!
	internal(set) var name: String!
	
	init() throws {
		
	}
	
	// MARK: encoding placeholders
	
	func encode() throws -> Data {
		return Data()
	}
	
	// MARK: decoding placeholders
	
	func decode(data: Data) throws {
		
	}
	
	func decode(bytes: inout UnsafePointer<UInt8>) throws {
		
	}
}
