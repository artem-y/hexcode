//
//  ColorFinder.swift
//  
//
//  Created by Artem Yelizarov on 17.06.2023.
//

import Foundation

protocol ColorFinding {
    func find(_ hex: String, in colorSets: [NamedColorSet]) -> [String]
}

final class ColorFinder: ColorFinding {
    func find(_ hex: String, in colorSets: [NamedColorSet]) -> [String] {
        let hex = hex.trimmingCharacters(in: ["#"])
        return colorSets
            .compactMap { namedSet in
                guard namedSet.colorSet.colors
                    .map(\.color.rgbHex)
                    .contains(hex) else { return nil }
                return namedSet.name
            }
    }
}
