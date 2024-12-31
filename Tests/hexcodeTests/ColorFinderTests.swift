@testable import hexcode
import XCTest
import SwiftyTestAssertions

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

    // MARK: - Test find duplicates

    func test_findDuplicates_inColorSetsWithMulticolorDuplicate_findsExpectedDuplicateValues() {
        // When
        let duplicates = sut.findDuplicates(in: [.defaultTextColorHex, .brandBlackColorHex])

        // Then
        XCTAssertEqual(duplicates, ["171717": ["brandBlackColorHex", "defaultTextHex (Any, Light)"]])
    }

    func test_findDuplicates_inColorSetsWithSingularDuplicate_findsExpectedDuplicateValues() {
        // Given
        let duplicatedWhite = NamedColorSet(
            name: "duplicatedWhite",
            colorSet: .Universal.Singular.white
        )
        let colorSets: [NamedColorSet] = [.whiteColorHex, .blackColorHex, duplicatedWhite]

        // When
        let colors = sut.findDuplicates(in: colorSets)

        // Then
        XCTAssertEqual(colors, ["FFFFFF": ["duplicatedWhite", "whiteColorHex"]])
    }

    func test_findDuplicates_inColorSetsWithMultipleDuplicates_returnsSortedExpectedDuplicateValues() {
        // Given
        var yellow: NamedColorSet = .sunflowerColorHex
        yellow.name = "yellow"

        var snowWhite: NamedColorSet = .whiteColorHex
        snowWhite.name = "snowWhite"

        let colorSets: [NamedColorSet] = [
            .blueColorHex,
            .sunflowerColorHex,
            .whiteColorHex,
            .blackColorHex,
            yellow,
            .redColorHex,
            snowWhite,
            .greenColorHex,
            .defaultTextColorHex,
        ]

        // When
        let colors = sut.findDuplicates(in: colorSets)

        // Then
        XCTAssertEqual(colors, [
            "F4EA2F": ["sunflowerHex (Dark)", "yellow (Dark)"],
            "FFFFFF": ["snowWhite", "whiteColorHex"],
            "E8DE2A": ["sunflowerHex (Any)", "yellow (Any)"],
        ])
    }

    func test_findDuplicates_inColorSetWithNoDuplicates_returnsEmptyDictionary() {
        // Given
        let colorSets: [NamedColorSet] = [.redColorHex, .greenColorHex, .blueColorHex]

        // When
        let colors = sut.findDuplicates(in: colorSets)

        // Then
        AssertEmpty(colors)
    }

    func test_findDuplicates_inColorSetWithInvalidColors_returnsEmptyDictionary() {
        // Given
        let invalidColor = ColorSet(
            colors: [
                .init(
                    color: .init(
                        colorSpace: .srgb,
                        components: .init(
                            alpha: "0",
                            red: "r",
                            green: "g",
                            blue: "b"
                        )
                    ),
                    idiom: .iPhone
                )
            ],
            info: .init(author: "-", version: 1.0)
        )
        let colorSets: [NamedColorSet] = [
            .init(name: "one", colorSet: invalidColor),
            .init(name: "two", colorSet: invalidColor),
        ]

        // When
        let colors = sut.findDuplicates(in: colorSets)

        // Then
        AssertEmpty(colors)
    }

}
