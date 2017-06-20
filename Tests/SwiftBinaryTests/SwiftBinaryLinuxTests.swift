import XCTest
@testable import SwiftBinary

class SwiftBinaryLinuxTests: XCTestCase {
    static let allTests = [
        ("testEncoderDecoder", testEncoderDecoder)
    ]

    func testEncoderDecoder() {
        let someObject = SomeClass()
        someObject.code1 = "Anderson Lucas C. Ramos"
        someObject.code2 = 10
        someObject.code3 = 59.12412
        someObject.data1 = someObject.code1.data(using: .utf8)
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

        assert(decoded.code1 == someObject.code1)
        assert(decoded.code2 == someObject.code2)
        assert(decoded.code3 == someObject.code3)
        assert(decoded.data1 == someObject.data1)
        assert(decoded.object1?.code4[0] == 5)
        assert(decoded.object1?.code4[4] == 1)
    }
}

class SomeClass : Convertable {
    var code1: String = "Value"
    var code2: Int = 0
    var code3: Float = 0
    var data1: Data? = nil
    var object1: SomeOtherClass? = nil

    func propertyRef(for key: String) -> Any {
        switch key {
            case "code1": return self.ref(from: &self.code1)
            case "code2": return self.ref(from: &self.code2)
            case "code3": return self.ref(from: &self.code3)
			case "data1": return self.ref(from: &self.data1)
            default: 
                self.object1 = SomeOtherClass()
                return self.ref(from: &self.object1)
        }
    } 

    func mapObject() -> [String: Any] {
		var object = Dictionary<String, Any>()
		object.append(self.code1, for: "code1")
		object.append(self.code2, for: "code2")
		object.append(self.code3, for: "code3")
		object.append(self.data1 as Any, for: "data1")
		object.append(self.object1 as Any, for: "object1")
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
        object.append(self.code4, for: "code4")
		return object
    }
}
