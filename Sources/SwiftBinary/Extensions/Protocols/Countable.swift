//
//  Countable.swift
//  SwiftBinary
//
//  Created by Anderson Lucas C. Ramos on 28/05/19.
//

import Foundation

protocol Countable {
    var length: Int32 { get }
    
    var data: Data { get }
}
