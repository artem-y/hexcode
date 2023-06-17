//
//  ColorFinderTests.swift
//  
//
//  Created by Artem Yelizarov on 17.06.2023.
//

@testable import hexcode
import XCTest

final class ColorFinderTests: XCTestCase {
    typealias SUT = ColorFinder

    // MARK: - Test find hex with hash

    func test_find_hexWithHash_inColorSetsWithSingleExpectedColor_findsExpectedColor() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("#FFFFFF", in: [.whiteColorHex])

        // Then
        XCTAssertEqual(colors, ["whiteColorHex"])
    }

    func test_find_hexWithHash_inEmptyArray_findsNothing() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("#FFFFFF", in: [])

        // Then
        XCTAssert(colors.isEmpty)
    }

    func test_find_hexWithHash_inColorSetsWithoutExpectedColor_findsNothing() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("#000000", in: [.whiteColorHex])

        // Then
        XCTAssert(colors.isEmpty)
    }

    // MARK: - Test find trimmed hex

    func test_find_trimmedHex_inColorSetsWithSingleExpectedColor_findsExpectedColor() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("FFFFFF", in: [.whiteColorHex])

        // Then
        XCTAssertEqual(colors, ["whiteColorHex"])
    }

    func test_find_trimmedHex_inEmptyArray_findsNothing() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("FFFFFF", in: [])

        // Then
        XCTAssert(colors.isEmpty)
    }

    func test_find_trimmedHex_inColorSetsWithoutExpectedColor_findsNothing() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("000000", in: [.whiteColorHex])

        // Then
        XCTAssert(colors.isEmpty)
    }
}
