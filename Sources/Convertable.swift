//
// Created by Anderson Lucas C. Ramos on 07/06/17.
//

import Foundation

public protocol DecodableProtocol {
    func propertyRef(for key: String) -> Any
}

public protocol EncodableProtocol {
    func mapObject() -> [String: Any]
}

public protocol Convertable: EncodableProtocol, DecodableProtocol {

}

public extension Convertable {
    func ref<T>(from: inout T) -> Any {
        return UnsafeMutablePointer<T>(&from)
    }
}
