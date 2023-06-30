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

    func run(colorHex: String, in directory: String? = nil) throws {
        let directory = directory ?? fileManager.currentDirectoryPath
        let colorAssets = try assetCollector.collectAssets(in: directory)
        let foundColors = colorFinder.find(colorHex, in: colorAssets)

        if foundColors.isEmpty {
            output("No \(colorHex) color found")
            return
        }

        foundColors.forEach { output($0) }
    }
}
