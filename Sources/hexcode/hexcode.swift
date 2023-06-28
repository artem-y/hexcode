import ArgumentParser

@main
struct hexcode: ParsableCommand {
    @Argument
    var colorHex: String

    @Option
    var directory: String?

    func validate() throws {
        try ArgumentValidator().validate(colorHex: colorHex)
    }

    func run() throws {
        try HexcodeApp().run(colorHex: colorHex, in: directory)
    }
}
