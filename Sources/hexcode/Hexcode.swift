import ArgumentParser

@main
struct Hexcode: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "hexcode",
        abstract: """
                  hexcode is a tool that finds Xcode color assets \
                  by their hexadecimal codes.
                  """,
        version: "hexcode 0.1.1"
    )

    @Argument
    var colorHex: String

    @Option
    var directory: String?

    func validate() throws {
        do {
            try ArgumentValidator().validate(colorHex: colorHex)
        } catch {
            throw ValidationError(
                String(describing: error)
            )
        }
    }

    func run() throws {
        try HexcodeApp().run(colorHex: colorHex, in: directory)
    }
}
