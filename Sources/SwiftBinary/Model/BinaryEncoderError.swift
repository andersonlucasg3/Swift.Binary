//
//  BinaryEncoderError.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

public enum BinaryEncoderError: Error {
    case typeNotExpected(type: Encodable.Type)
}
