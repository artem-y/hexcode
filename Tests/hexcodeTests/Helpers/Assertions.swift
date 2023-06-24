//
//  Assertions.swift
//  
//
//  Created by Artem Yelizarov on 24.06.2023.
//

import XCTest

/// Passes if expression throws expected error.
/// - parameter expression: Throwable expression.
/// - parameter error: Expected `Equatable` error.
/// - parameter file: The file where the assertion failed.
/// - parameter line: The line on which the assertion failed.
func Assert<T, E: Error & Equatable>(
    _ expression: @autoclosure (() throws -> T),
    throwsError error: E,
    file: StaticString = #filePath,
    line: UInt = #line
) {

    XCTAssertThrowsError(
        try expression(),
        "Failed to throw error",
        file: file,
        line: line
    ) { actualError in
        guard let actualError = actualError as? E else {
            XCTFail(
                "Threw wrong kind of error, expected \(E.self)",
                file: file,
                line: line
            )
            return
        }

        XCTAssertEqual(
            error,
            actualError,
            file: file,
            line: line
        )
    }
}
