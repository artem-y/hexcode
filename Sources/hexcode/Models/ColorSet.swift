//
//  ColorSet.swift
//  
//
//  Created by Artem Yelizarov on 17.06.2023.
//

import Foundation

struct ColorSet: Decodable, Equatable {
    struct Info: Decodable, Equatable {
        var author: String
        var version: Double
    }

    var colors: [ColorAsset]
    var info: Info
}
