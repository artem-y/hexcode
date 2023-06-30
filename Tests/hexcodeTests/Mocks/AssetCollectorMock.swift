@testable import hexcode
import Foundation

final class AssetCollectorMock {
    enum Call: Equatable {
        case collectAssetsIn(directory: String)
        case getFileManager
        case setFileManager(FileManager)
    }

    struct CallResults {
        var collectAssets: Result<[NamedColorSet], Error> = .success([])
        var fileManager: FileManager = FileManagerMock()
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
    var fileManager: FileManager {
        get {
            calls.append(.getFileManager)
            return results.fileManager
        }

        set {
            calls.append(.setFileManager(newValue))
        }
    }

    func collectAssets(in directory: String) throws -> [NamedColorSet] {
        calls.append(.collectAssetsIn(directory: directory))
        return try results.collectAssets.get()
    }
}
