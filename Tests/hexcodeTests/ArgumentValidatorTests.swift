//
//  ArgumentValidatorTests.swift
//  
//
//  Created by Artem Yelizarov on 28.06.2023.
//

@testable import hexcode
import XCTest

final class ArgumentValidatorTests: XCTestCase {
    typealias SUT = ArgumentValidator

    private var sut = SUT()

    // MARK: - Life Cycle

    override func setUp() {
        sut = SUT()
    }

    // MARK: - Tests

    func test_validateColorhex_validHex_completesWithNoErrors() {
        // Then
        XCTAssertNoThrow(
            try sut.validate(colorHex: "FFFFFF") // When
        )
    }

    func test_validateColorhex_validHex_withHexSymbol_completesWithNoErrors() {
        // Then
        XCTAssertNoThrow(
            try sut.validate(colorHex: "#000000") // When
        )
    }

    func test_validateColorhex_whenTooShort_throwsTooShortError() {
        // Then
        Assert(
            try sut.validate(colorHex: "12345"), // When
            throwsError: ArgumentValidator.ColorHexError.tooShort
        )
    }

    func test_validateColorhex_whenTooShort_withHexSymbol_throwsTooShortError() {
        // Then
        Assert(
            try sut.validate(colorHex: "#12345"), // When
            throwsError: ArgumentValidator.ColorHexError.tooShort
        )
    }

    func test_validateColorhex_whenTooLong_throwsTooLongError() {
        // Then
        Assert(
            try sut.validate(colorHex: "1234567"), // When
            throwsError: ArgumentValidator.ColorHexError.tooLong
        )
    }

    func test_validateColorhex_whenHasInvalidSymbols_throwsInbalidSymbolsError() {
        // Then
        Assert(
            try sut.validate(colorHex: "ABCXYZ"), // When
            throwsError: ArgumentValidator.ColorHexError.hasInvalidSymbols
        )
    }
}
