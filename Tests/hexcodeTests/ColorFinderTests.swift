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

    func test_findHexWithHash_inColorSetsWithSingleExpectedColor_findsExpectedColor() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("#FFFFFF", in: [.whiteUniversalSingularColorSet])

        // Then
        XCTAssertEqual(colors, [.whiteUniversalSingularColorSet])
    }

    func test_findHexWithHash_inEmptyArray_findsNothing() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("#FFFFFF", in: [])

        // Then
        XCTAssert(colors.isEmpty)
    }

    func test_findHexWithHash_inColorSetsWithoutExpectedColor_findsNothing() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("#000000", in: [.whiteUniversalSingularColorSet])

        // Then
        XCTAssert(colors.isEmpty)
    }
}
