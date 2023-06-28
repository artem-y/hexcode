import ArgumentParser

@main
struct hexcode: ParsableCommand {
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
