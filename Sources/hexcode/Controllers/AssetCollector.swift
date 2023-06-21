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

        let contents = try fileManager.contentsOfDirectory(atPath: directory)
        let namedColorSets = contents.compactMap { path in
            findColorSet(at: "\(directory)/\(path)")
                .map {
                    NamedColorSet(
                        name: path.replacingOccurrences(of: ".colorset", with: ""),
                        colorSet: $0
                    )
                }
        }
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
    private func findColorSet(at path: String) -> ColorSet? {
        let path = path + "/Contents.json"
        guard let fileData = fileManager.contents(atPath: path) else { return nil }
        guard let colorSet = try? JSONDecoder().decode(ColorSet.self, from: fileData) else { return nil }
        return colorSet
    }
}
