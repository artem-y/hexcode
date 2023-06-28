//
//  NamedColorSet+Stubs.swift
//  
//
//  Created by Artem Yelizarov on 18.06.2023.
//

@testable import hexcode

extension NamedColorSet {
    static let whiteColorHex: Self = NamedColorSet(
        name: "whiteColorHex",
        colorSet: .Universal.Singular.white
    )

    static let blackColorHex: Self = NamedColorSet(
        name: "blackColorHex",
        colorSet: .Universal.Singular.black
    )

    static let redColorHex: Self = NamedColorSet(
        name: "redColorHex",
        colorSet: .Universal.Singular.red
    )

    static let greenColorHex: Self = NamedColorSet(
        name: "greenColorHex",
        colorSet: .Universal.Singular.green
    )

    static let blueColorHex: Self = NamedColorSet(
        name: "blueColorHex",
        colorSet: .Universal.Singular.blue
    )

    static let sunflowerColorHex: Self = NamedColorSet(
        name: "sunflowerHex",
        colorSet: .Universal.Multiple.sunflower
    )

    static let defaultTextColorHex: Self = NamedColorSet(
        name: "defaultTextHex",
        colorSet: .Universal.Multiple.defaultText
    )

    static let cyanColorHex: Self = NamedColorSet(
        name: "cyanColorHex",
        colorSet: .Universal.Multiple.cyan
    )
}
