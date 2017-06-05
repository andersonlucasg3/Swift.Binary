import XCTest
@testable import SwiftBinary

class Swift_BinaryTests: XCTestCase {
    static let allTests = [
        ("testEncoderDecoder", testEncoderDecoder)
    ]

    func testEncoderDecoder() {
        let someObject = SomeClass()
        someObject.code1 = "Anderson Lucas C. Ramos"
        someObject.code2 = 10
        someObject.code3 = 59.12412

        print("starting encoding ------------------------------")

        let encoder = Encoder()
        let data = try! encoder.encode(object: someObject)

        print("end of encoding --------------------------------")
        print("starting decoding --------------------------------")

        var decoded = SomeClass()

        let decoder = Decoder()
        try! decoder.decode(fromData: data, intoObject: decoded)

        print("end of decoding ---------------------------------")

        assert(someObject.code1 == decoded.code1)
        assert(someObject.code2 == decoded.code2)
        assert(someObject.code3 == decoded.code3)
    }
}

class SomeClass : NSObject, DecoderProtocol {
    var code1: String = "Value"
    var code2: Int = 0
    var code3: Float = 0

    func mapping(_ value: Any, forKey key: String) {
        switch key {
        case "code1":
            self.code1 = value as! String
            break

        case "code2":
            self.code2 = Int(value as! Int64)
            break

        case "code3":
            self.code3 = value as! Float
            break

        default: break
        }
    }
}