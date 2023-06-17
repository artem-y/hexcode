//
//  ColorSet+Extensions.swift
//  
//
//  Created by Artem Yelizarov on 17.06.2023.
//

@testable import hexcode

extension ColorSet {
    static let whiteUniversalSingularColorSet: Self = .init(
        colors: [
            .init(
                color: .init(
                    colorSpace: .srgb,
                    components: .init(
                        alpha: "1.000",
                        red: "0xFF",
                        green: "0xFF",
                        blue: "0xFF"
                    )
                ),
                idiom: .universal
            )
        ],
        info: .init(
            author: "xcode",
            version: 1
        )
    )
}
