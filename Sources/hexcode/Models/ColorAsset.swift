//
//  ColorAsset.swift
//  
//
//  Created by Artem Yelizarov on 17.06.2023.
//

import Foundation

struct ColorAsset: Decodable, Equatable {
    var color: Color
    var idiom: Idiom
    var appearances: [Appearance]?
    var subtype: String?
}

// MARK: - ColorAsset.Idiom

extension ColorAsset {
    enum Idiom: String, Decodable {
        case universal
        case iPhone = "iphone"
        case iPad = "ipad"
        case car
        case mac
        case watch
        case tv
    }
}

// MARK: - ColorAsset.Appearance

extension ColorAsset {
    struct Appearance: Decodable, Equatable {
        var appearance: String
        var value: String
    }
}

// MARK: - ColorAsset.Color

extension ColorAsset {
    struct Color: Decodable, Equatable {
        var colorSpace: ColorSpace
        var components: Components

        var rgbHex: String {
            var rgb = [
                components.red,
                components.green,
                components.blue
            ]

            if !rgb.allSatisfy({ $0.hasPrefix("0x") }) {
                rgb = rgb.compactMap(convertToHexadecimal)
            }

            return rgb
                .reduce("", +)
                .replacingOccurrences(of: "0x", with: "")
        }

        enum CodingKeys: String, CodingKey {
            case components
            case colorSpace = "color-space"
        }
    }
}

extension ColorAsset.Color {
    private func convertToHexadecimal(_ component: String) -> String? {
        guard !component.contains("."),
              let intComponent = Int(component) else { return nil }

        return String(format:"%02X", intComponent)
    }
}

// MARK: - ColorAsset.Color.ColorSpace

extension ColorAsset.Color {
    enum ColorSpace: String, Decodable {
        case srgb
        case extendedSrgb = "extended-srgb"
        case extendedLinearSrgb = "extended-linear-srgb"
    }
}

// MARK: - ColorAsset.Color.Components

extension ColorAsset.Color {
    struct Components: Decodable, Equatable {
        var alpha: String
        var red: String
        var green: String
        var blue: String
    }
}
