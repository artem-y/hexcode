import Foundation

/// Finds color asset folders and converts them to Swift objects.
protocol AssetCollecting {
    /// `FileManager` instance used for the search.
    var fileManager: FileManager { get set }
    /// Finds all color sets in the directory and its subdirectories.
    /// - parameter directory: Path to the directory to search for color sets.
    /// - throws: Errors when valid directory not found at given path or can't read content.
    /// - returns: Named color sets found in given directory, sorted by name.
    func collectAssets(in directory: String) async throws -> [NamedColorSet]
}

final class AssetCollector: AssetCollecting {
    var fileManager: FileManager = .default

    func collectAssets(in directory: String) async throws -> [NamedColorSet] {
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: directory, isDirectory: &isDirectory) else {
            throw Error.directoryNotFound
        }

        guard isDirectory.boolValue else {
            throw Error.notADirectory
        }

        let paths = try fileManager.contentsOfDirectory(atPath: directory)
        let namedColorSets = await self.findColorSets(
            at: paths.map { "\(directory)/\($0)"},
            in: directory
        )
        return namedColorSets.sorted(by: { $0.name < $1.name })
    }
}

// MARK: - Error

extension AssetCollector {
    enum Error: Swift.Error, Equatable, CustomStringConvertible {
        case directoryNotFound
        case notADirectory

        var description: String {
            switch self {
            case .directoryNotFound: "Directory not found"
            case .notADirectory: "Not a directory"
            }
        }
    }
}

// MARK: - Private

extension AssetCollector {
    private func findColorSets(
        at paths: [String],
        in searchRootDirectory: String,
        alreadyFoundColorSets: [NamedColorSet] = []
    ) async -> [NamedColorSet] {
        let colorSets = await withTaskGroup(of: [NamedColorSet].self) { group in
            for path in paths {
                group.addTask {
                    let contentAtPath = self.determineContentType(at: path)

                    switch contentAtPath {
                    case .colorSet(let colorSet):
                        return self.makeNamedColorset(
                            from: colorSet,
                            at: path,
                            in: searchRootDirectory
                        )

                    case .otherDirectory(let subpaths):
                        guard !subpaths.isEmpty else { return [] }
                        let fullSubpaths = subpaths.map { "\(path)/\($0)" }
                        let colorSetsFromSubdirectory = await self.findColorSets(
                            at: fullSubpaths,
                            in: searchRootDirectory,
                            alreadyFoundColorSets: alreadyFoundColorSets
                        )
                        return colorSetsFromSubdirectory

                    case .file, .none:
                        return []
                    }
                }
            }

            return await group.reduce(alreadyFoundColorSets, +)
        }

        return colorSets
    }

    private func makeNamedColorset(
        from colorSet: ColorSet,
        at path: String,
        in searchRootDirectory: String
    ) -> [NamedColorSet] {

        let assetName = getAssetName(from: path, in: searchRootDirectory)
        let namedColorSet = NamedColorSet(name: assetName, colorSet: colorSet)
        return [namedColorSet]
    }

    private func determineContentType(at path: String) -> PathContentType? {
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: path, isDirectory: &isDirectory),
              isDirectory.boolValue else { return .file }

        if !path.hasSuffix(".colorset"), let subpaths = try? contents(at: path) {
            return .otherDirectory(subpaths: subpaths)
        } else {
            return readColorSet(at: path).map(PathContentType.colorSet)
        }
    }

    private func contents(at directory: String) throws -> [String] {
        try fileManager.contentsOfDirectory(atPath: directory)
    }

    private func getAssetName(from path: String, in searchRootDirectory: String) -> String {
        let trimmedPath = String(path.trimmingPrefix(searchRootDirectory + "/"))
        return URL(filePath: trimmedPath)
            .deletingPathExtension()
            .relativeString
    }

    private func readColorSet(at path: String) -> ColorSet? {
        let path = path + "/Contents.json"
        guard let fileData = fileManager.contents(atPath: path),
              let colorSet = try? JSONDecoder().decode(ColorSet.self, from: fileData) else { return nil }
        return colorSet
    }
}
