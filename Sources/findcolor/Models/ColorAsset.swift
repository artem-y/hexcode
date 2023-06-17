//
//  ColorAsset.swift
//  
//
//  Created by Artem Yelizarov on 17.06.2023.
//

import Foundation

struct ColorAsset: Decodable, Equatable {
    struct Color: Decodable, Equatable {
        enum ColorSpace: String, Decodable {
            case srgb
            case extendedSrgb = "extended-srgb"
            case extendedLinearSrgb = "extended-linear-srgb"
        }

        struct Components: Decodable, Equatable {
            var alpha: String
            var blue: String
            var green: String
            var red: String
        }

        var colorSpace: ColorSpace
        var components: Components

        enum CodingKeys: String, CodingKey {
            case components
            case colorSpace = "color-space"
        }
    }

    enum Idiom: String, Decodable {
        case universal
        case iPhone = "iphone"
        case iPad = "ipad"
        case car
        case mac
        case watch
        case tv
    }

    struct Appearance: Decodable, Equatable {
        var appearance: String
        var value: String
    }

    var color: Color
    var idiom: Idiom
    var appearances: [Appearance]?
    var subtype: String?
}