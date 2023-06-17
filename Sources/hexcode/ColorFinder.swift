//
//  ColorFinder.swift
//  
//
//  Created by Artem Yelizarov on 17.06.2023.
//

import Foundation

final class ColorFinder {
    func find(_ hex: String, in colorSets: [ColorSet]) -> [ColorSet] {
        let hex = hex.trimmingCharacters(in: ["#"])
        return colorSets.filter { colorSet in
            colorSet.colors
                .map(\.color.rgbHex)
                .contains(hex)
        }
    }
}
