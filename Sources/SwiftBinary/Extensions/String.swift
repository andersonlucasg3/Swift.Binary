//
//  String.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

extension String: Countable {
    var length: Int32 {
        return Int32.init(self.lengthOfBytes(using: .utf8))
    }
    
    var data: Data {
        return self.data(using: .utf8)!
    }
}
