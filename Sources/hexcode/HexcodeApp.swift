import Foundation

final class HexcodeApp {
    private let fileManager: FileManager
    private let assetCollector: AssetCollecting
    private let colorFinder: ColorFinding
    private let output: ((String) -> Void)

    init(
        fileManager: FileManager = .default,
        assetCollector: AssetCollecting = AssetCollector(),
        colorFinder: ColorFinding = ColorFinder(),
        outputFunction: @escaping ((String) -> Void) = { print($0) }
    ) {
        self.fileManager = fileManager
        self.colorFinder = colorFinder
        self.output = outputFunction

        var assetCollector = assetCollector
        assetCollector.fileManager = fileManager
        self.assetCollector = assetCollector
    }

    /// Entry point for the default `find-color` subcommand logic.
    /// - Parameters:
    ///   - colorHex: Raw input argument for hexadecimal color code.
    ///   - directory: Optional custom directory from user input. Defaults to current directory.
    /// - throws: All unhandled errors that can be thrown out to standard output.
    func runFindColor(colorHex: String, in directory: String? = nil) async throws {
        let directory = directory.map(expandTilde) ?? fileManager.currentDirectoryPath
        let colorAssets = try await assetCollector.collectAssets(in: directory)
        let foundColors = colorFinder.find(colorHex, in: colorAssets)

        if foundColors.isEmpty {
            output("No \(colorHex) color found")
            return
        }

        foundColors.forEach { output($0) }
    }

    /// Entry point for the `find-duplicates` subcommand logic.
    /// - Parameter directory: Optional custom directory from user input. Defaults to current directory.
    /// - throws: All unhandled errors that can be thrown out to standard output.
    func runFindDuplicates(in directory: String? = nil) async throws {
        let directory = directory.map(expandTilde) ?? fileManager.currentDirectoryPath
        let colorAssets = try await assetCollector.collectAssets(in: directory)
        let foundDuplicates = colorFinder.findDuplicates(in: colorAssets)

        if foundDuplicates.isEmpty {
            output("No duplicates found")
            return
        }

        var hasMoreThanOneDuplicate = false
        foundDuplicates
            .sorted { $0.key < $1.key }
            .forEach { duplicate in

                if hasMoreThanOneDuplicate {
                    output("--")
                }

                duplicate.value.forEach { color in
                    output("#\(duplicate.key) \(color)")
                }

                if !hasMoreThanOneDuplicate {
                    hasMoreThanOneDuplicate = true
                }
            }
    }
}

// MARK: - Private

extension HexcodeApp {
    private func expandTilde(_ path: String) -> String {
        path.replacingOccurrences(
            of: "~",
            with: fileManager.homeDirectoryForCurrentUser.relativePath
        )
    }
}
