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
        let colors = sut.find("#FFFFFF", in: [.blackColorHex, .whiteColorHex])

        // Then
        XCTAssertEqual(colors, ["whiteColorHex"])
    }

    func test_find_hexWithHash_inColorSetsWithMultipleMatches_findsExpectedColor() {
        // Given
        let sut = SUT()
        let duplicatedWhite = NamedColorSet(
            name: "duplicatedWhite",
            colorSet: .Universal.Singular.white
        )
        let colorSets = [.whiteColorHex, .blackColorHex, duplicatedWhite]

        // When
        let colors = sut.find("#FFFFFF", in: colorSets)

        // Then
        XCTAssertEqual(colors, ["whiteColorHex", "duplicatedWhite"])
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
        let colors = sut.find("FFFFFF", in: [.blackColorHex, .whiteColorHex])

        // Then
        XCTAssertEqual(colors, ["whiteColorHex"])
    }

    func test_find_trimmedHex_inColorSetsWithMultipleMatches_findsExpectedColor() {
        // Given
        let sut = SUT()
        let duplicatedWhite = NamedColorSet(
            name: "duplicatedWhite",
            colorSet: .Universal.Singular.white
        )
        let colorSets = [.whiteColorHex, .blackColorHex, duplicatedWhite]

        // When
        let colors = sut.find("FFFFFF", in: colorSets)

        // Then
        XCTAssertEqual(colors, ["whiteColorHex", "duplicatedWhite"])
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

    // MARK: - Test find appearances

    func test_find_withMultipleAppearances_whenMatchesOnlyOne_addsAppearanceToName() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("#F4EA2F", in: [.sunflowerColorHex])

        // Then
        XCTAssertEqual(colors, ["sunflowerHex (Dark)"])
    }

    func test_find_withMultipleAppearances_whenMatchesOnlyAny_addsAnyToName() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("#E8DE2A", in: [.sunflowerColorHex])

        // Then
        XCTAssertEqual(colors, ["sunflowerHex (Any)"])
    }

    func test_find_withMultipleAppearances_whenMatchesMultipleAppearances_addsAllToName() {
        // Given
        let sut = SUT()

        // When
        let colors = sut.find("#171717", in: [.defaultTextColorHex])

        // Then
        XCTAssertEqual(colors, ["defaultTextHex (Any, Light)"])
    }
}
