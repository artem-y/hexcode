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
            static let white = makeColorSet(red: "0xFF", green: "0xFF", blue: "0xFF")
            static let black = makeColorSet(red: "0x00", green: "0x00", blue: "0x00")
            static let red = makeColorSet(red: "0xFF", green: "0x00", blue: "0x00")
            static let green = makeColorSet(red: "0x00", green: "0xFF", blue: "0x00")
            static let blue = makeColorSet(red: "0x00", green: "0x00", blue: "0xFF")
        }

        enum Multiple {
            static let sunflower: ColorSet = .init(
                colors: [
                    makeColorAsset(red: "0xE8", green: "0xDE", blue: "0x2A"),
                    makeColorAsset(red: "0xF4", green: "0xEA", blue: "0x2F", appearance: "dark"),
                ],
                info: .default
            )

            static let defaultText: ColorSet = .init(
                colors: [
                    makeColorAsset(red: "0x17", green: "0x17", blue: "0x17"),
                    makeColorAsset(red: "0xE7", green: "0xE7", blue: "0xE7", appearance: "dark"),
                    makeColorAsset(red: "0x17", green: "0x17", blue: "0x17", appearance: "light"),
                ],
                info: .default
            )

            static let cyan: ColorSet = .init(
                colors: [
                    makeColorAsset(red: "0x00", green: "0xFF", blue: "0xFF"),
                    makeColorAsset(red: "0x00", green: "0xFF", blue: "0xFF", appearance: "light"),
                    makeColorAsset(red: "0x00", green: "0xFF", blue: "0xFF", appearance: "dark"),
                ],
                info: .default
            )
        }
    }
}

// MARK: - Helpers

extension ColorSet {
    private static func makeColorSet(red: String, green: String, blue: String) -> Self {
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
            info: .default
        )
    }

    private static func makeColorAsset(
        red: String,
        green: String,
        blue: String,
        appearance: String? = nil
    ) -> ColorAsset {
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
            idiom: .universal,
            appearances: appearance.map {
                [
                    .init(
                        appearance: "luminosity",
                        value: $0
                    )
                ]
            }
        )
    }
}

extension ColorSet.Info {
    static let `default` = Self(
        author: "xcode",
        version: 1
    )
}
