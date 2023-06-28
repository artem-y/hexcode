//
//  ColorTests.swift
//  
//
//  Created by Artem Yelizarov on 17.06.2023.
//

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
        XCTAssert(rgbHex.isEmpty)
    }
}
