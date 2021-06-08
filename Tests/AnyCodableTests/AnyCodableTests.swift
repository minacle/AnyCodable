@testable import AnyCodable
import XCTest

class AnyCodableTests: XCTestCase {

    func testEquivalency() {
        let boolean = true
        let integer = 42
        let double = 3.141592653589793
        let string = "string"
        let array = [1, 2, 3]
        let nested = [
            "a": "alpha",
            "b": "bravo",
            "c": "charlie",
        ]
        XCTAssertEqual(AnyCodable(boolean), AnyCodable(boolean))
        XCTAssertEqual(AnyCodable(integer), AnyCodable(integer))
        XCTAssertEqual(AnyCodable(double), AnyCodable(double))
        XCTAssertEqual(AnyCodable(string), AnyCodable(string))
        XCTAssertEqual(AnyCodable(array), AnyCodable(array))
        XCTAssertEqual(AnyCodable(nested), AnyCodable(nested))
        XCTAssertNotEqual(AnyCodable(array), AnyCodable([1, 2, 4]))
        XCTAssertNotEqual(AnyCodable(nested), AnyCodable(["a": "apple", "b": "banana", "c": "cherry"]))
    }

    func testJSONDecoding() throws {
        let json = """
        {
            "boolean": true,
            "integer": 42,
            "double": 3.141592653589793,
            "string": "string",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            },
            "null": null
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let dictionary = try decoder.decode([String: AnyCodable].self, from: json)

        XCTAssertEqual(dictionary["boolean"]?.value as! Bool, true)
        XCTAssertEqual(dictionary["integer"]?.value as! Int, 42)
        XCTAssertEqual(dictionary["double"]?.value as! Double, 3.141592653589793, accuracy: 0.001)
        XCTAssertEqual(dictionary["string"]?.value as! String, "string")
        XCTAssertEqual(dictionary["array"]?.value as! [Int], [1, 2, 3])
        XCTAssertEqual(dictionary["nested"]?.value as! [String: String], ["a": "alpha", "b": "bravo", "c": "charlie"])
        XCTAssertEqual(dictionary["null"]?.value as! NSNull, NSNull())
    }

    func testJSONEncoding() throws {
        let dictionary: [String: AnyCodable] = [
            "boolean": true,
            "integer": 42,
            "double": 3.141592653589793,
            "string": "string",
            "array": [1, 2, 3],
            "nested": [
                "a": "alpha",
                "b": "bravo",
                "c": "charlie",
            ],
            "null": nil
        ]

        let encoder = JSONEncoder()

        let json = try encoder.encode(dictionary)
        let encodedJSONObject = try JSONSerialization.jsonObject(with: json, options: []) as! NSDictionary

        let expected = """
        {
            "boolean": true,
            "integer": 42,
            "double": 3.141592653589793,
            "string": "string",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            },
            "null": null
        }
        """.data(using: .utf8)!
        let expectedJSONObject = try JSONSerialization.jsonObject(with: expected, options: []) as! NSDictionary

        XCTAssertEqual(encodedJSONObject, expectedJSONObject)
    }
}
