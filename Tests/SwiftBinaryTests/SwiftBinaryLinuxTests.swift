#if os(Linux)
	
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
        someObject.object1 = SomeOtherClass()
        someObject.object1?.code4 = [5, 4, 3, 2, 1]

        print("starting encoding ------------------------------")

        let encoder = Encoder()
        let data = try! encoder.encode(object: someObject)

        print("end of encoding --------------------------------")
        print("starting decoding --------------------------------")

        let decoded = SomeClass()

        let decoder = Decoder()
        try! decoder.decode(fromData: data, intoObject: decoded)

        print("end of decoding ---------------------------------")

        assert(someObject.code1 == decoded.code1)
        assert(someObject.code2 == decoded.code2)
        assert(someObject.code3 == decoded.code3)
        assert(someObject.object1?.code4[0] == 5)
        assert(someObject.object1?.code4[4] == 1)
    }
}

class SomeClass : NSObject, Convertable {
    var code1: String = "Value"
    var code2: Int = 0
    var code3: Float = 0
    var object1: SomeOtherClass? = nil

    func propertyRef(for key: String) -> Any {
        switch key {
            case "code1": return self.ref(from: &self.code1)
            case "code2": return self.ref(from: &self.code2)
            case "code3": return self.ref(from: &self.code3)
            default: 
                self.object1 = SomeOtherClass()
                return self.ref(from: &self.object1)
        }
    } 

    func mapObject() -> [String: Any] {
        var object: [String: Any] = [
            "code1": self.code1,
            "code2": self.code2,
            "code3": self.code3,
        ]
        if let obj = self.object1 {
            object["object1"] = obj
        }
        return object
    }
}

class SomeOtherClass : SomeClass {
    var code4: Array<Int> = [1, 2, 3, 4, 5]

    override func propertyRef(for key: String) -> Any {
        switch key {
            case "code4": return self.ref(from: &self.code4)
            default: return super.propertyRef(for: key)
        }
    }

    override func mapObject() -> [String: Any] {
        var object = super.mapObject()
        object["code4"] = self.code4
        return object
    }
}

#endif
