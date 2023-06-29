import XCTest
@testable import hexcode

final class ColorSetTests: XCTestCase {

    // MARK: - Tests

    func test_decodeColorSet_withSingleColor_succeeds() throws {
        // Given
        let colorData = try XCTUnwrap(ColorSetJSON.white.data(using: .utf8))

        // When
        let colorSet: ColorSet = try JSONDecoder().decode(
            ColorSet.self,
            from: colorData
        )

        // Then
        XCTAssertEqual(colorSet, .Universal.Singular.white)
    }

    func test_decodeColorSet_fromFile_succeeds() throws {
        // Given
        let resourcePath = try makeResourcePath()
        let filePath = "\(resourcePath)/Assets.xcassets/whiteColorHex.colorset/Contents.json"
        let colorData = try XCTUnwrap(
            FileManager.default.contents(atPath: filePath)
        )

        // When
        let colorSet: ColorSet = try JSONDecoder().decode(
            ColorSet.self,
            from: colorData
        )

        // Then
        XCTAssertEqual(colorSet, .Universal.Singular.white)
    }
}
