@testable import hexcode
import XCTest

final class hexcodeEndToEndTests: XCTestCase {
    typealias SUT = hexcode

    private var hexcodeExecutableURL: URL?
    private var resourcePath = ""

    // MARK: - Life Cycle

    override func setUpWithError() throws {
        hexcodeExecutableURL = makeHexcodeExecutableURL()
        resourcePath = try makeResourcePath()
    }

    // MARK: - Tests

    func test_hexcode_inAssetCatalogWithSingleAsset_findsAsset() throws {
        // Given
        let arguments = ["#FFFFFF", "--directory=\(resourcePath)/Assets.xcassets"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "whiteColorHex\n")
        XCTAssertEqual(error, "")
    }

    func test_hexcode_inDicectoryWithoutAssets_outputsNoColorsFoundMessage() throws {
        // Given
        let arguments = ["123456", "--directory=\(resourcePath)/FakeContentFolder"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "No 123456 color found\n")
        XCTAssertEqual(error, "")
    }

    func test_hexcode_inNonExistentDirectory_exitsWithDirectoryNotFoundError() throws {
        // Given
        let arguments = ["010203", "--directory=\(resourcePath)/ImaginaryFolder"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "")
        XCTAssertEqual(error, "Error: Directory not found\n")
    }

    func test_hexcode_inNonExistentDirectory_exitsWithNotADirectoryError() throws {
        // Given
        let arguments = ["0ABCDF", "--directory=\(resourcePath)/EmptyFile"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "")
        XCTAssertEqual(error, "Error: Not a directory\n")
    }

    func test_hexcode_inCatalogWithMultipleSubdirectories_findsAsset() throws {
        // Given
        let arguments = ["0000FF", "--directory=\(resourcePath)/AssetsInSubdirectories.xcassets"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "blueColorHex\n")
        XCTAssertEqual(error, "")
    }

    func test_hexcode_inAssetWithMultipleMatchingAppearances_findsAssetWithMatchingAppearances() throws {
        // Given
        let arguments = ["#171717", "--directory=\(resourcePath)/Assets.xcassets"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "defaultTextHex (Any, Light)\n")
        XCTAssertEqual(error, "")
    }

    func test_hexcode_inAssetWithOneMatchingAppearance_findsAssetWithMatchingAppearance() throws {
        // Given
        let arguments = ["#E7E7E7", "--directory=\(resourcePath)/Assets.xcassets"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "defaultTextHex (Dark)\n")
        XCTAssertEqual(error, "")
    }

    func test_hexcode_whenAssetHasRGBIntegerComponents_findsAsset() throws {
        // Given
        let arguments = ["#FFA500", "--directory=\(resourcePath)/Assets.xcassets"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "orange\n")
        XCTAssertEqual(error, "")
    }

    func test_hexcode_inCatalogWithMixedHexAndIntegerComponentAssets_findsAllMatchingAssets() throws {
        // Given
        let arguments = ["#00FFFF", "--directory=\(resourcePath)/Assets.xcassets"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(
            output,
            """
            cyan (Any, Light)
            cyanColorHex
            cyanWithMixedComponentTypes\n
            """
        )
        XCTAssertEqual(error, "")
    }

    func test_hexcode_withTooLongColorHex_exitsWithTooLongError() throws {
        // Given
        let arguments = ["fafa33c", "--directory=\(resourcePath)/Assets.xcassets"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "")
        XCTAssert(error.contains("Error: Color hex is too long\n"))
    }

    func test_hexcode_withTooShortColorHex_exitsWithTooShortError() throws {
        // Given
        let arguments = ["#ffa50", "--directory=\(resourcePath)/Assets.xcassets"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "")
        XCTAssert(error.contains("Error: Color hex is too short\n"))
    }

    func test_hexcode_withInvalidColorHex_exitsWithInvalidColorHexError() throws {
        // Given
        let arguments = ["#12345R", "--directory=\(resourcePath)/Assets.xcassets"]

        // When
        let (output, error) = try runHexcode(arguments: arguments)

        // Then
        XCTAssertEqual(output, "")
        XCTAssert(error.contains("Error: Color hex contains invalid symbols\n"))
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

    private func runHexcode(arguments: [String]) throws -> (output: String, error: String) {
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
        let outputString = String(data: outputData, encoding: .utf8) ?? ""

        let errorData = standardError.fileHandleForReading.availableData
        let errorString = String(data: errorData, encoding: .utf8) ?? ""

        return (output: outputString, error: errorString)
    }
}
