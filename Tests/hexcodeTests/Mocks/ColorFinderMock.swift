//
//  ColorFinderMock.swift
//  
//
//  Created by Artem Yelizarov on 24.06.2023.
//

@testable import hexcode
import Foundation

final class ColorFinderMock {
    enum Call: Equatable {
        case find(hex: String, colorSets: [NamedColorSet])
    }

    struct CallResults {
        var find: [String] = []
    }

    private(set) var calls: [Call] = []
    var results = CallResults()

    func reset() {
        calls = []
        results = .init()
    }
}

// MARK: - ColorFinding

extension ColorFinderMock: ColorFinding {
    func find(_ hex: String, in colorSets: [NamedColorSet]) -> [String] {
        calls.append(.find(hex: hex, colorSets: colorSets))
        return results.find
    }
}
