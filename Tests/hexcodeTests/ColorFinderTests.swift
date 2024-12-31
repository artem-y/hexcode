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

    // MARK: - Test performance

#if !CI
    func test_performance_findDuplicates_measureSpeed() {
        // Given
        let repeatingColorSets: [NamedColorSet] = Array(repeating: .blueColorHex, count: 10)
        + Array(repeating: .redColorHex, count: 10)
        + Array(repeating: .greenColorHex, count: 10)
        + Array(repeating: .blackColorHex, count: 10)
        + Array(repeating: .whiteColorHex, count: 10)
        + Array(repeating: .cyanColorHex, count: 10)
        + Array(repeating: .brandBlackColorHex, count: 10)
        + Array(repeating: .defaultTextColorHex, count: 10)
        + Array(repeating: .sunflowerColorHex, count: 10)
        + Array(repeating: .cyanColorHex, count: 10)

        let allDifferentColorSets: [NamedColorSet] = (0..<255).map {
            NamedColorSet(
                name: "\($0) colorset",
                colorSet: ColorSet(
                    colors: [
                        ColorAsset(
                            color: .init(
                                colorSpace: .srgb,
                                components: .init(
                                    alpha: "0xFF",
                                    red: String(format: "0x%02X", $0),
                                    green: "0x00",
                                    blue: "0xFF"
                                )
                            ),
                            idiom: .iPhone
                        )
                    ],
                    info: .init(author: "author", version: 1.0)
                )
            )
        }

        var repeatingColorSetResults: [String: [String]] = [:]
        var allDifferentColorSetResults: [String: [String]] = [:]

        // Then
        self.measure {
            // When
            repeatingColorSetResults = sut.findDuplicates(in: repeatingColorSets)
            allDifferentColorSetResults = sut.findDuplicates(in: allDifferentColorSets)
        }

        // Then
        XCTAssertEqual(
            repeatingColorSetResults,
            [
                "000000": Array(repeating: "blackColorHex", count: 10),
                "FFFFFF": Array(repeating: "whiteColorHex", count: 10),
                "FF0000": Array(repeating: "redColorHex", count: 10),
                "00FF00": Array(repeating: "greenColorHex", count: 10),
                "E7E7E7": Array(repeating: "defaultTextHex (Dark)", count: 10),
                "F4EA2F": Array(repeating: "sunflowerHex (Dark)", count: 10),
                "00FFFF": Array(repeating: "cyanColorHex", count: 20),
                "0000FF": Array(repeating: "blueColorHex", count: 10),
                "171717": Array(repeating: "brandBlackColorHex", count: 10) + Array(repeating: "defaultTextHex (Any, Light)", count: 10),
                "E8DE2A": Array(repeating: "sunflowerHex (Any)", count: 10)
            ]
        )
        AssertEmpty(allDifferentColorSetResults)
    }
#endif
}
