import ArgumentParser
import Foundation

@main
struct hexcode: ParsableCommand {
    @Argument
    var colorHex: String

    @Option
    var directory: String?

    mutating func run() throws {
        try HexcodeApp().run(colorHex: colorHex, in: directory)
    }
}
