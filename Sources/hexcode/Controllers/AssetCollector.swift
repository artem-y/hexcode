//
//  AssetCollector.swift
//  
//
//  Created by Artem Yelizarov on 21.06.2023.
//

import Foundation

final class AssetCollector {
    private let fileManager = FileManager.default

    func collectAssets(in directory: String) throws -> [NamedColorSet] {
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: directory, isDirectory: &isDirectory) else {
            throw Error.directoryNotFound
        }

        guard isDirectory.boolValue else {
            throw Error.notADirectory
        }

        let paths = try fileManager.contentsOfDirectory(atPath: directory)
        let namedColorSets = findColorSets(at: paths.map { "\(directory)/\($0)"})
        return namedColorSets.sorted(by: { $0.name < $1.name })
    }
}

// MARK: - Error

extension AssetCollector {
    enum Error: Swift.Error, Equatable {
        case directoryNotFound
        case notADirectory
    }
}

// MARK: - Private

extension AssetCollector {
    private func findColorSets(at paths: [String]) -> [NamedColorSet] {
        guard !paths.isEmpty else { return [] }

        var colorSets: [NamedColorSet] = []
        var subPaths: [String] = []

        for path in paths {
            let contentAtPath = determineContentType(at: path)

            switch contentAtPath {
            case .colorSet(let colorSet):
                let assetName = getAssetName(from: path)
                let namedColorSet = NamedColorSet(name: assetName, colorSet: colorSet)
                colorSets.append(namedColorSet)

            case .otherDirectory(let subpaths):
                subPaths.append(contentsOf: subpaths.map { "\(path)/\($0)" })

            case .file, .none:
                continue
            }
        }

        if !subPaths.isEmpty {
            let colorSetsFromSubdirectory = findColorSets(at: subPaths)
            colorSets.append(contentsOf: colorSetsFromSubdirectory)
        }

        return colorSets
    }

    private func determineContentType(at path: String) -> PathContentType? {
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: path, isDirectory: &isDirectory) else { return nil }
        guard isDirectory.boolValue else { return .file }

        if !path.hasSuffix(".colorset"), let subpaths = try? contents(at: path) {
            return .otherDirectory(subpaths: subpaths)
        } else {
            return readColorSet(at: path).map(PathContentType.colorSet)
        }
    }

    private func contents(at directory: String) throws -> [String] {
        try fileManager.contentsOfDirectory(atPath: directory)
    }

    private func getAssetName(from path: String) -> String {
        makeURL(from: path)
            .deletingPathExtension()
            .lastPathComponent
    }

    private func makeURL(from path: String) -> URL {
        if #available(macOS 13.0, *) {
            return URL(filePath: path)
        } else {
            return URL(fileURLWithPath: path)
        }
    }

    private func readColorSet(at path: String) -> ColorSet? {
        let path = path + "/Contents.json"
        guard let fileData = fileManager.contents(atPath: path) else { return nil }
        guard let colorSet = try? JSONDecoder().decode(ColorSet.self, from: fileData) else { return nil }
        return colorSet
    }
}
