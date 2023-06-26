import ArgumentParser

@main
struct hexcode: ParsableCommand {
    @Argument
    var colorHex: String

    @Option
    var directory: String?

    func run() throws {
        try HexcodeApp().run(colorHex: colorHex, in: directory)
    }
}
