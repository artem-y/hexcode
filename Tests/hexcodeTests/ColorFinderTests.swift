@testable import hexcode
import XCTest

final class ColorFinderTests: XCTestCase {
    typealias SUT = ColorFinder

    private var sut = SUT()

    // MARK: - Life Cycle

    override func setUp() {
        sut = SUT()
    }

    // MARK: - Test find hex with hash

    func test_find_hexWithHash_inColorSetsWithSingleExpectedColor_findsExpectedColor() {
        // When
        let colors = sut.find("#FFFFFF", in: [.blackColorHex, .whiteColorHex])

        // Then
        XCTAssertEqual(colors, ["whiteColorHex"])
    }

    func test_find_hexWithHash_inColorSetsWithMultipleMatches_findsExpectedColor() {
        // Given
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
        // When
        let colors = sut.find("#FFFFFF", in: [])

        // Then
        AssertEmpty(colors)
    }

    func test_find_hexWithHash_inColorSetsWithoutExpectedColor_findsNothing() {
        // When
        let colors = sut.find("#000000", in: [.whiteColorHex])

        // Then
        AssertEmpty(colors)
    }

    // MARK: - Test find trimmed hex

    func test_find_trimmedHex_inColorSetsWithSingleExpectedColor_findsExpectedColor() {
        // When
        let colors = sut.find("ffffff", in: [.blackColorHex, .whiteColorHex])

        // Then
        XCTAssertEqual(colors, ["whiteColorHex"])
    }

    func test_find_trimmedHex_inColorSetsWithMultipleMatches_findsExpectedColor() {
        // Given
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
        // When
        let colors = sut.find("FFFFFF", in: [])

        // Then
        AssertEmpty(colors)
    }

    func test_find_trimmedHex_inColorSetsWithoutExpectedColor_findsNothing() {
        // When
        let colors = sut.find("000000", in: [.whiteColorHex])

        // Then
        AssertEmpty(colors)
    }

    // MARK: - Test find appearances

    func test_find_withMultipleAppearances_whenMatchesOnlyOne_addsAppearanceToName() {
        // When
        let colors = sut.find("#F4EA2F", in: [.sunflowerColorHex])

        // Then
        XCTAssertEqual(colors, ["sunflowerHex (Dark)"])
    }

    func test_find_withMultipleAppearances_whenMatchesOnlyAny_addsAnyToName() {
        // When
        let colors = sut.find("#E8DE2A", in: [.sunflowerColorHex])

        // Then
        XCTAssertEqual(colors, ["sunflowerHex (Any)"])
    }

    func test_find_withMultipleAppearances_whenMatchesMultipleAppearances_addsAllToName() {
        // When
        let colors = sut.find("#171717", in: [.defaultTextColorHex])

        // Then
        XCTAssertEqual(colors, ["defaultTextHex (Any, Light)"])
    }

    func test_find_withMultipleAppearances_whenMatchesAllAppearances_addsNothingToName() {
        // When
        let colors = sut.find("#00FFFF", in: [.cyanColorHex])

        // Then
        XCTAssertEqual(colors, ["cyanColorHex"])
    }
}
