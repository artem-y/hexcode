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

    func test_rgbHex_withFloatComponents_returnsConvertedHex() {
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
        XCTAssertEqual(rgbHex, "007FFF")
    }

    func test_rgbHex_withFloatComponentsAllZeros_returnsConvertedHex() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "0.0",
                green: "0.0",
                blue: "0.0"
            )
        )

        // When
        let rgbHex = sut.rgbHex

        // Then
        XCTAssertEqual(rgbHex, "000000")
    }

    func test_rgbHex_withFloatComponentsAllOnes_returnsConvertedHex() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "1.0",
                green: "1.0",
                blue: "1.0"
            )
        )

        // When
        let rgbHex = sut.rgbHex

        // Then
        XCTAssertEqual(rgbHex, "FFFFFF")
    }

    func test_rgbHex_withInvalidFloatValue_returnsEmptyString() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "0.200",
                green: "1.001",
                blue: "0.500"
            )
        )

        // When
        let rgbHex = sut.rgbHex

        // Then
        AssertEmpty(rgbHex)
    }

    func test_rgbHex_withNegativeFloatValue_returnsEmptyString() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "0.300",
                green: "0.999",
                blue: "-0.500"
            )
        )

        // When
        let rgbHex = sut.rgbHex

        // Then
        AssertEmpty(rgbHex)
    }

    func test_rgbHex_withFloatComponentCloseBeforeNextColorValue_returnsCorrectConvertedHex() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "0.100",
                green: "0.357",
                blue: "0.670"
            )
        )

        // When
        let rgbHex = sut.rgbHex

        // Then
        XCTAssertEqual(rgbHex, "195BAA")
    }

    func test_rgbHex_withFloatComponentCloseAfterPreviousColorValue_returnsCorrectConvertedHex() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "0.100",
                green: "0.357",
                blue: "0.671"
            )
        )

        // When
        let rgbHex = sut.rgbHex

        // Then
        XCTAssertEqual(rgbHex, "195BAB")
    }

    func test_rgbHex_withHexAndIntComponents_returnsEmptyString() {
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

    func test_rgbHex_withIntAndFloatComponents_returnsEmptyString() {
        // Given
        let sut = SUT(
            colorSpace: .srgb,
            components: .init(
                alpha: "1",
                red: "0",
                green: "0.0",
                blue: "255"
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
