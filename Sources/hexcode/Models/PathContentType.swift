//
//  PathContentType.swift
//  
//
//  Created by Artem Yelizarov on 24.06.2023.
//

enum PathContentType {
    case colorSet(ColorSet)
    case file
    case otherDirectory(subpaths: [String])
}
