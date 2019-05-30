//
//  Data.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

extension Data: Countable {
    var length: Int32 {
        return Int32.init(self.count)
    }
    
    var data: Data {
        return self
    }
    
    init(pointer: UnsafePointer<UInt8>, length: Int32) {
        self = Data.init(buffer: UnsafeBufferPointer<UInt8>.init(start: pointer, count: Int.init(length)))
    }
}
