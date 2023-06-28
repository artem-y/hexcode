import XCTest
@testable import hexcode

final class ColorTests: XCTestCase {
    typealias SUT = ColorAsset.Color

    func test_rgbHex_withValidHexComponents_returnsValidHex() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "0xF6",
                green: "0xFA",
                blue: "0x0C"
            )
        )

        // When
        let rgbHex = sut.rgbHex

        // Then
        XCTAssertEqual(rgbHex, "F6FA0C")
    }

    func test_rgbHex_withIntegerComponents_returnsConvertedHex() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "12",
                green: "34",
                blue: "56"
            )
        )

        // When
        let rgbHex = sut.rgbHex

        // Then
        XCTAssertEqual(rgbHex, "0C2238")
    }

    func test_rgbHex_withFloatComponents_returnsEmptyString() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "0.0",
                green: "0.5",
                blue: "1.0"
            )
        )

        // When
        let rgbHex = sut.rgbHex

        // Then
        AssertEmpty(rgbHex)
    }

    func test_rgbHex_withDifferentTypesOfComponents_returnsEmptyString() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "0x00",
                green: "15",
                blue: "0xFF"
            )
        )

        // When
        let rgbHex = sut.rgbHex

        // Then
        AssertEmpty(rgbHex)
    }

    func test_rgbHex_withHexPrefixWithoutValue_returnsEmptyString() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "0x00",
                green: "0xFF",
                blue: "0x"
            )
        )

        // When
        let rgbHex = sut.rgbHex

        // Then
        AssertEmpty(rgbHex)
    }
}
