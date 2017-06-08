//
// Created by Anderson Lucas C. Ramos on 07/06/17.
//

#if os(Linux)

import Foundation

public protocol DecodableProtocol : NSObjectProtocol {
    func propertyReference(for key: String) -> Any
}

public protocol EncodableProtocol : NSObjectProtocol {
    func mapObject() -> [String: Any]
}

public protocol Convertable: EncodableProtocol, DecodableProtocol {

}

public extension Convertable {
    func getParamReference<T>(from: inout T) -> Any {
        return UnsafeMutablePointer<T>(&from)
    }
}

#endif
