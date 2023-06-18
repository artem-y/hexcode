//
//  NamedColorSet.swift
//  
//
//  Created by Artem Yelizarov on 18.06.2023.
//

import Foundation

struct NamedColorSet: Decodable, Equatable {
    var name: String
    var colorSet: ColorSet
}
