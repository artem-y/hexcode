import ArgumentParser

struct FindDuplicates: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "find-duplicates",
        abstract: "Finds duplicate Xcode color assets."
    )

    @Option
    var directory: String?

    func run() async throws {
        try await HexcodeApp().runFindDuplicates(in: directory)
    }
}
