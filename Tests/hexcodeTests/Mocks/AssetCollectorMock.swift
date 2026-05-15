@testable import hexcode
import Foundation

final class AssetCollectorMock {
    enum Call: Equatable {
        case collectAssetsIn(directory: String)
    }

    struct CallResults {
        var collectAssets: Result<[NamedColorSet], Error> = .success([])
    }

    private(set) var calls: [Call] = []
    var results = CallResults()

    func reset() {
        calls = []
        results = .init()
    }
}

// MARK: - AssetCollecting

extension AssetCollectorMock: AssetCollecting {
    func collectAssets(in directory: String) throws -> [NamedColorSet] {
        calls.append(.collectAssetsIn(directory: directory))
        return try results.collectAssets.get()
    }
}
