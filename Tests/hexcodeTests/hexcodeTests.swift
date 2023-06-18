import XCTest
@testable import hexcode

final class hexcodeTests: XCTestCase {
    private let whiteColorString = """
          {
            "colors" : [
              {
                "color" : {
                  "color-space" : "srgb",
                  "components" : {
                    "alpha" : "1.000",
                    "blue" : "0xFF",
                    "green" : "0xFF",
                    "red" : "0xFF"
                  }
                },
                "idiom" : "universal"
              }
            ],
            "info" : {
              "author" : "xcode",
              "version" : 1
            }
          }
          """

    // MARK: - Tests

    func test_decodeColorSet_withSingleColor_succeeds() throws {
        // Given
        let colorData = try XCTUnwrap(whiteColorString.data(using: .utf8))

        // When
        let colorSet: ColorSet = try JSONDecoder().decode(
            ColorSet.self,
            from: colorData
        )

        // Then
        XCTAssertEqual(colorSet, .whiteUniversalSingularColorSet)
    }

    func test_decodeColorSet_fromFile_succeeds() throws {
        // Given
        let resourcePath = try XCTUnwrap(Bundle.module.resourcePath)
        let filePath = "\(resourcePath)/Resources/Assets.xcassets/whiteColorHex.colorset/Contents.json"
        let colorData = try XCTUnwrap(
            FileManager.default.contents(atPath: filePath)
        )

        // When
        let colorSet: ColorSet = try JSONDecoder().decode(
            ColorSet.self,
            from: colorData
        )

        // Then
        XCTAssertEqual(colorSet, .whiteUniversalSingularColorSet)
    }
}
