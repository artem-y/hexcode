@testable import hexcode

final class ColorFinderMock {
    enum Call: Equatable {
        case find(hex: String, colorSets: [NamedColorSet])
        case findDuplicates(in: [NamedColorSet])
    }

    struct CallResults {
        var find: [String] = []
        var findDuplicates: [String: [String]] = [:]
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

    func findDuplicates(in colorSets: [NamedColorSet]) -> [String: [String]] {
        calls.append(.findDuplicates(in: colorSets))
        return results.findDuplicates
    }
}
