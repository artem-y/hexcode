@testable import hexcode
import XCTest

final class hexcodeEndToEndTests: XCTestCase {
    typealias SUT = hexcode

    private var hexcodeExecutableURL: URL?
    private var resourcePath = ""

    // MARK: - Life Cycle

    override func setUpWithError() throws {
        hexcodeExecutableURL = makeHexcodeExecutableURL()
        resourcePath = try XCTUnwrap(Bundle.module.resourcePath)
    }

    // MARK: - Tests

    func test_hexcode_inAssetCatalogWithSingleAsset_findsAsset() throws {
        // Given
        let arguments = ["#FFFFFF", "--directory=\(resourcePath)/Resources/Assets.xcassets"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "whiteColorHex\n")
        XCTAssertEqual(error, "")
    }

    func test_hexcode_inDicectoryWithoutAssets_outputsNoColorsFoundMessage() throws {
        // Given
        let arguments = ["123456", "--directory=\(resourcePath)/Resources/FakeContentFolder"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "No 123456 color found\n")
        XCTAssertEqual(error, "")
    }

    func test_hexcode_inNonExistentDirectory_exitsWithDirectoryNotFoundError() throws {
        // Given
        let arguments = ["010203", "--directory=\(resourcePath)/Resources/ImaginaryFolder"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "")
        XCTAssertEqual(error, "Error: Directory not found\n")
    }

    func test_hexcode_inNonExistentDirectory_exitsWithNotADirectoryError() throws {
        // Given
        let arguments = ["0ABCDF", "--directory=\(resourcePath)/Resources/EmptyFile"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "")
        XCTAssertEqual(error, "Error: Not a directory\n")
    }

    func test_hexcode_inCatalogWithMultipleSubdirectories_findsAsset() throws {
        // Given
        let arguments = ["0000FF", "--directory=\(resourcePath)/Resources/AssetsInSubdirectories.xcassets"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "blueColorHex\n")
        XCTAssertEqual(error, "")
    }
}

// MARK: - Private

extension hexcodeEndToEndTests {
    private func makeHexcodeExecutableURL() -> URL? {
        let bundleURL = Bundle(for: Self.self)
            .bundleURL
            .deletingLastPathComponent()

        var components = URLComponents(
            url: bundleURL,
            resolvingAgainstBaseURL: false
        ) ?? .init()

        components.path += "/hexcode"
        return components.url
    }

    private func runHexcode(arguments: [String]) throws -> (output: String?, error: String?) {
        let process = Process()
        process.arguments = arguments

        let standardOutput = Pipe()
        process.standardOutput = standardOutput

        let standardError = Pipe()
        process.standardError = standardError

        process.executableURL = hexcodeExecutableURL
        try process.run()
        process.waitUntilExit()

        let outputData = standardOutput.fileHandleForReading.availableData
        let outputString = String(data: outputData, encoding: .utf8)

        let errorData = standardError.fileHandleForReading.availableData
        let errorString = String(data: errorData, encoding: .utf8)

        return (output: outputString, error: errorString)
    }
}
