import Foundation
import XCTest
@testable import findcolor

final class findcolorTests: XCTestCase {
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
        XCTAssertEqual(colorSet, .whiteUniversalSingularColorSet)
    }
}

// MARK: - Helpers

fileprivate extension ColorSet {
    static let whiteUniversalSingularColorSet: Self = .init(
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
}
