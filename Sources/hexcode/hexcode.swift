import ArgumentParser
import Foundation

@main
struct hexcode: ParsableCommand {
    @Argument
    var colorHex: String

    mutating func run() throws {
        try HexcodeApp().run(colorHex: colorHex)
    }
}
