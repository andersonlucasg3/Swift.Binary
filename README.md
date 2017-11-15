[![Build Status](https://travis-ci.org/andersonlucasg3/Swift.Binary.svg?branch=master)](https://travis-ci.org/andersonlucasg3/Swift.Binary)

# Swift.Binary
Binary auto-parsing for **Swift** **3.2** and **4**.

## Examples
For using the Encoder and Decoder classes you just need to declare your swift classes where all the properties are `@objc dynamic` and the class **MUST** extend from `NSObject`.
Other thing is that `Obj-c` representable objects may be optional, but non `obj-c` representable objects **MUST** be defined non optional.
But the `@objc dynamic` diretive will obligate you to define it right.

## Writing example:
Example of the implementation for converting objects to data.
```swift
import Swift_Binary // very important

class Employee: NSObject {
    @objc fileprivate(set) dynamic var name: String?
    @objc fileprivate(set) dynamic var age: Int = 0
}

class Boss: Employee {
    @objc fileprivate(set) dynamic var employees: [Employee]?
}

let employee1: Employee = Employee()
employee1.name = "John Apple Juice"
employee1.age = 35

let boss: Boss = Boss()
boss.name = "Steve James Apple Orange Juice"
boss.age = 65
boss.employees?.append(employee1)

let encoder = Encoder()
let binaryData: Data = try! encoder.encode(boss)
```

## Parsing example:
Example of the implementation for converting data to objects.
Obs: Using the same classes from above.
```swift
let binaryData: Data = // binary NSData

let decoder = Decoder()
let boss: Boss = try! decoder.decode(binaryData)

assert(boss.name == "Steve James Apple Orange Juice")
assert(boss.age == 65)
assert(boss.employees![0].name == "John Apple Juice")
assert(boss.employees![0].age == 35)
```

Any doubts, post an issue or create a pull request. Pull requests are welcome.
Thanks.
