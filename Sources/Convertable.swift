//
// Created by Anderson Lucas C. Ramos on 07/06/17.
//

#if os(Linux)

import Foundation

public protocol DecodableProtocol : NSObjectProtocol {
    func mapping() -> [String: UnsafeMutablePointer<Any>]
}

public protocol EncodableProtocol : NSObjectProtocol {
    func mapObject() -> [String: Any]
}

protocol Convertable: EncodableProtocol, DecodableProtocol {
    
}

#endif