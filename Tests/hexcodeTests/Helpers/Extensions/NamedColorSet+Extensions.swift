//
//  NamedColorSet+Extensions.swift
//  
//
//  Created by Artem Yelizarov on 18.06.2023.
//

@testable import hexcode

extension NamedColorSet {
    static let whiteColorHex: Self = NamedColorSet(
        name: "whiteColorHex",
        colorSet: .whiteUniversalSingularColorSet
    )

    static let blackColorHex: Self = NamedColorSet(
        name: "blackColorHex",
        colorSet: .blackUniversalSingularColorSet
    )
}
