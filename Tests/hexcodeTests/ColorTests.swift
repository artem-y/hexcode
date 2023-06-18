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

    func test_rgbHex_withValidHexComponents_returnsValidHexValue() {
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

    func test_rgbHex_withNumericComponents_isEmpty() {
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
        XCTAssert(rgbHex.isEmpty)
    }
}
