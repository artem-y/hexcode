import ArgumentParser

struct FindColor: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "find-color",
        abstract: """
                  Default subcommand that finds Xcode color assets \
                  by their hexadecimal codes.
                  """
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

    func run() async throws {
        try await HexcodeApp().runFindColor(colorHex: colorHex, in: directory)
    }
}
