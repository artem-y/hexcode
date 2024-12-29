import ArgumentParser

@main
struct Hexcode: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "hexcode",
        abstract: """
                  hexcode is a tool that finds Xcode color assets \
                  by their hexadecimal codes.
                  """,
        usage: "hexcode <color-hex> [--directory <directory>]",
        version: "hexcode feature/find-duplicates",
        subcommands: [
            FindColor.self,
            FindDuplicates.self,
        ],
        defaultSubcommand: FindColor.self
    )
}