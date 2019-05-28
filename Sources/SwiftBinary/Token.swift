//
//  Token.swift
//  SwiftServer
//
//  Created by Anderson Lucas C. Ramos on 11/04/17.
//
//

import Foundation

public class Token: Encodable, Decodable {
	public internal(set) var type: DataType!
	public internal(set) var name: String!
	
	public init() throws {
		
	}
	
	// MARK: encoding placeholders
	
	public func encode() throws -> Data {
		return Data()
	}
	
	// MARK: decoding placeholders
	
	public func decode(data: Data) throws {
		
	}
	
    public func decode(bytes: inout UnsafePointer<UInt8>) throws {
		
	}
}
