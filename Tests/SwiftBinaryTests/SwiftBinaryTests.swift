#if os(iOS) || os(OSX)

import XCTest
@testable import SwiftBinary

class SubClass : NSObject {
	dynamic var value: Int = 10
	dynamic var value2: Int = 25
	dynamic var array: [Data] = [
		"testando".data(using: .utf8)!
	]
}

class TestCommand: NSObject {
	dynamic var int1: Int = 123
	dynamic var int2: Int = 225
	dynamic var string: String = "Testando"
	dynamic var sub: SubClass?
	dynamic var array: [Int] = [1, 2, 3, 4, 5]
	dynamic var classArray: [SubClass] = [
		SubClass(),
		SubClass()
	]
	dynamic var emptyArray: [Float] = []
}

class Swift_BinaryTests: XCTestCase {
	func testIvarToken() {
		// Testing integer value as int64
		let token1 = try! IvarToken<Int64>(name: "value", value: 25)
		let data1 = try! token1.encode()
		
		let decodedToken1 = try! IvarToken<Int64>()
		try! decodedToken1.decode(data: data1)
		assert(decodedToken1.type == .int64)
		assert(decodedToken1.name == "value")
		assert(decodedToken1.value == 25)
		
		// Testing string value
		let token2 = try! IvarToken<String>(name: "title", value: "Mr. Anderson")
		let data2 = try! token2.encode()
		
		let decodedToken2 = try! IvarToken<String>()
		try! decodedToken2.decode(data: data2)
		assert(decodedToken2.type == .string)
		assert(decodedToken2.name == "title")
		assert(decodedToken2.value == "Mr. Anderson")
		
		// Testing double value as float
		let token3 = try! IvarToken<Double>(name: "value", value: 50.555)
		let data3 = try! token3.encode()
		
		let decodedToken3 = try! IvarToken<Double>()
		try! decodedToken3.decode(data: data3)
		assert(decodedToken3.type == .double)
		assert(decodedToken3.name == "value")
		assert(decodedToken3.value == 50.555)
		
		// Testing float value
		let token4 = try! IvarToken<Float>(name: "value", value: 1123.23)
		let data4 = try! token4.encode()
		
		let decodedToken4 = try! IvarToken<Float>()
		try! decodedToken4.decode(data: data4)
		assert(decodedToken4.type == .float)
		assert(decodedToken4.name == "value")
		assert(decodedToken4.value == 1123.23)
	}
	
	func testIvarTokenData() {
		let token = try! IvarToken<Data>(name: "data", value: "Eu sou legal em data".data(using: .utf8)!)
		let data = try! token.encode()
		
		let decodedToken = try! IvarToken<Data>()
		try! decodedToken.decode(data: data)
		let recoveredString = String(data: decodedToken.value, encoding: .utf8)
		assert(recoveredString == "Eu sou legal em data")
	}
	
	func testEqualOperatorForDataType() {
		assert(DataType.int8 == Int8.self)
		assert(DataType.int64 == Int64.self)
		assert(DataType.string == String.self)
		assert(DataType.string == NSString.self)
		assert(DataType.float == Float.self)
		assert(DataType.double == Double.self)
		assert(Int.self == DataType.int64) // testing inverse operator
	}
	
	func testIvarObjectEncodeDecode() {
		let childObject = try! IvarObject(name: "child", value: [
			try! IvarToken(name: "name", value: "Ainda vou por um nome!"),
			try! IvarToken(name: "age", value: 5)
			])
		
		var fields = Array<Token>()
		fields.append(try! IvarToken(name: "name", value: "Anderson Lucas C. Ramos"))
		fields.append(try! IvarToken(name: "age", value: 28))
		fields.append(try! IvarToken(name: "weight", value: 100.0))
		fields.append(childObject)
		
		var object = try! IvarObject(name: "client", value: fields)
		let data = try! object.encode()
		
		object = try! IvarObject()
		try! object.decode(data: data)
		
		let name = object.value[0] as! IvarToken<String>
		let age = object.value[1] as! IvarToken<Int64>
		let weight = object.value[2] as! IvarToken<Double>
		let child = object.value[3] as! IvarObject
		let childName = child.value[0] as! IvarToken<String>
		let childAge = child.value[1] as! IvarToken<Int64>
		
		assert(name.value == "Anderson Lucas C. Ramos")
		assert(age.value == 28)
		assert(weight.value == 100)
		
		assert(childName.value == "Ainda vou por um nome!")
		assert(childAge.value == 5)
	}
	
	func testIvarArrayEncodeDecode() {
		let array = try! IvarArray<Int64>(name: "teste", value: [
			50, 40, 30, 20, 10
			])
		let data = try! array.encode()
		
		let newArray = try! IvarArray<Int64>()
		try! newArray.decode(data: data)
		
		assert(newArray.value[0] == 50)
		assert(newArray.value[1] == 40)
		assert(newArray.value[2] == 30)
		assert(newArray.value[3] == 20)
		assert(newArray.value[4] == 10)
	}
	
	func testIvarObjectArrayEncodeDecode() {
		let array = try! IvarArray<IvarObject>(name: "teste", value: [
			IvarObject(name: "object1", value: [
				IvarToken(name: "token1", value: 100)
				]),
			IvarObject(name: "object2", value: [
				IvarToken(name: "token2", value: 200)
				])
			])
		let data = try! array.encode()
		
		let newArray = try! IvarArray<IvarObject>()
		try! newArray.decode(data: data)
		
		assert(newArray.value[0].name == "object1")
		assert((newArray.value[0].value[0] as! IvarToken<Int64>).value == 100)
		assert(newArray.value[1].name == "object2")
		assert((newArray.value[1].value[0] as! IvarToken<Int64>).value == 200)
	}
	
	func testObjectEncDec() {
		let encoder = ObjectEncoder()
		let decoder = ObjectDecoder()
		
		let first = TestCommand()
		first.sub = SubClass()
		let data = try! encoder.encodeAny(object: first)
		
		let command = TestCommand()
		try! decoder.decodeAny(fromData: data, intoObject: command)
		assert(command.int1 == 123)
		assert(command.int2 == 225)
		assert(command.string == "Testando")
		assert(command.sub?.value == 10)
		assert(command.sub?.value2 == 25)
		assert(String(data: command.sub!.array[0], encoding: .utf8) == "testando")
		assert(command.array[0] == 1)
		assert(command.array[4] == 5)
		assert(command.classArray[0].value == 10)
		assert(command.classArray[1].value2 == 25)
		assert(command.emptyArray.count == 0)
	}
}

#endif
