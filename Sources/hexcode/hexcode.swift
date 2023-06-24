import ArgumentParser
import Foundation

@main
struct hexcode: ParsableCommand {
    @Argument
    var colorHex: String

    mutating func run() throws {
        let assetCollector = AssetCollector()
        let colorFinder = ColorFinder()

        let colorAssets = try assetCollector.collectAssets(in: FileManager.default.currentDirectoryPath)
        let foundColors = colorFinder.find(colorHex, in: colorAssets)

        if foundColors.isEmpty {
            print("No \(colorHex) color found")
            return
        }

        foundColors.forEach { print($0) }
    }
}
