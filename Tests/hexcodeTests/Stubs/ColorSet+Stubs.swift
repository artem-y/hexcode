//
//  ColorSet+Stubs.swift
//  
//
//  Created by Artem Yelizarov on 17.06.2023.
//

@testable import hexcode

// MARK: - Stubs

extension ColorSet {
    enum Universal {
        enum Singular {
            static let white: ColorSet = makeFromComponents(
                red: "0xFF",
                green: "0xFF",
                blue: "0xFF"
            )

            static let black: ColorSet = makeFromComponents(
                red: "0x00",
                green: "0x00",
                blue: "0x00"
            )

            static let red: ColorSet = makeFromComponents(
                red: "0xFF",
                green: "0x00",
                blue: "0x00"
            )

            static let green: ColorSet = makeFromComponents(
                red: "0x00",
                green: "0xFF",
                blue: "0x00"
            )

            static let blue: ColorSet = makeFromComponents(
                red: "0x00",
                green: "0x00",
                blue: "0xFF"
            )
        }
    }
}

// MARK: - Helpers

extension ColorSet {
    static func makeFromComponents(red: String, green: String, blue: String) -> Self {
        .init(
            colors: [
                .init(
                    color: .init(
                        colorSpace: .srgb,
                        components: .init(
                            alpha: "1.000",
                            red: red,
                            green: green,
                            blue: blue
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
}
