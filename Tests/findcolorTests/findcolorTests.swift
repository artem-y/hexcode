import Foundation
import XCTest
@testable import findcolor

final class findcolorTests: XCTestCase {
    func test_decodeColorSet_withSingleColor_succeeds() throws {
        // Given
        let whiteColorString = """
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
        let colorData = try XCTUnwrap(whiteColorString.data(using: .utf8))

        // When
        let colorSet: ColorSet = try JSONDecoder().decode(
            ColorSet.self,
            from: colorData
        )

        // Then
        let expectedColorSet = ColorSet(
            colors: [
                .init(
                    color: .init(
                        colorSpace: .srgb,
                        components: .init(
                            alpha: "1.000",
                            blue: "0xFF",
                            green: "0xFF",
                            red: "0xFF"
                        )
                    ),
                    idiom: .universal
                )
            ],
            info: .init(
                author: "xcode",
                version: 1
            )
        )
        XCTAssertEqual(colorSet, expectedColorSet)
    }

    func decodeColorSet_fromFile_succeeds() throws {
        // Given
        let filePath = try XCTUnwrap(
            Bundle.main.url(
                forResource: "Assets.xcassets/whiteColor.colorset/Contents",
                withExtension: "json"
            )
        )
        let colorData = try Data(contentsOf: filePath)

        // When
        let colorSet: ColorSet = try JSONDecoder().decode(
            ColorSet.self,
            from: colorData
        )

        // Then
        let expectedColorSet = ColorSet(
            colors: [
                .init(
                    color: .init(
                        colorSpace: .srgb,
                        components: .init(
                            alpha: "1.000",
                            blue: "0xFF",
                            green: "0xFF",
                            red: "0xFF"
                        )
                    ),
                    idiom: .universal
                )
            ],
            info: .init(
                author: "xcode",
                version: 1
            )
        )
        XCTAssertEqual(colorSet, expectedColorSet)
    }
}
