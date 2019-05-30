//
//  BinaryDecoderError.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 30/05/19.
//

import Foundation

public enum BinaryDecoderError: Error {
    case typeNotExpected(value: UInt8)
}
