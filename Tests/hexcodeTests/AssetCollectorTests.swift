@testable import hexcode
import XCTest
import SwiftyTestAssertions

final class AssetCollectorTests: XCTestCase {
    typealias SUT = AssetCollector

    private var mocks = Mocks()
    private var sut = SUT()

    // MARK: - Life Cycle

    override func setUp() {
        mocks = Mocks()
        sut = SUT()
        sut.fileManager = mocks.fileManager
    }

    // MARK: - Tests

    func test_collectAssets_inAssetCatalogDirectory_findsAssets() async throws {
        // Given
        let catalogPath = "Assets.xcassets"
        setMockDirectory(at: catalogPath, with: ["whiteColorHex.colorset", "blackColorHex.colorset"])
        setMockAsset(at: catalogPath + "/whiteColorHex.colorset", with: ColorSetJSON.white)
        setMockAsset(at: catalogPath + "/blackColorHex.colorset", with: ColorSetJSON.black)

        // When
        let assets = try await sut.collectAssets(in: catalogPath)

        // Then
        XCTAssertEqual(assets, [.blackColorHex, .whiteColorHex])
    }

    func test_collectAssets_inDicectoryWithInvalidAssets_findsNothing() async throws {
        // Given
        let directory = "/some/directory"

        setMockDirectory(at: directory, with: ["Contents.json", "notAColor.colorset", "brokenColor.colorset"])

        setMockFile(at: "\(directory)/Contents.json", with: data("{\"contents\": \"nope\"}"))

        setMockAsset(at: "\(directory)/brokenColor.colorset", with: "{\"color\": \"magenta\"}")

        setMockDirectory(at: "\(directory)/notAColor.colorset", with: ["text.txt"])
        setMockFile(at: "\(directory)/notAColor.colorset/text.txt", with: data("hello world"))

        // When
        let assets = try await sut.collectAssets(in: directory)

        // Then
        AssertEmpty(assets)
    }

    func test_collectAssets_inNonExistentDirectory_throwsDirectoryNotFoundError() async throws {
        // Given
        let path = "/nonExistentDirectory"
        mocks.fileManager.results.fileExistsAtPath[path] = nil

        await AssertAsync(
            try await sut.collectAssets(in: path), // When
            throwsError: SUT.Error.directoryNotFound // Then
        )
    }

    func test_collectAssets_atPathThatIsFile_throwsNotADirectoryError() async throws {
        // Given
        let filePath = "/someFile"
        mocks.fileManager.results.fileExistsAtPath[filePath] = .file

        await AssertAsync(
            try await sut.collectAssets(in: filePath), // When
            throwsError: SUT.Error.notADirectory // Then
        )
    }

    func test_collectAssets_inCatalogWithMultipleSubdirectories_findsAllAssets() async throws {
        // Given
        let catalogPath = "/Resources/AssetsInSubdirectories.xcassets"
        setMockDirectory(at: catalogPath, with: ["OtherColors", "redColorHex.colorset"])
        setMockAsset(at: "\(catalogPath)/redColorHex.colorset", with: ColorSetJSON.red)

        let otherColorsDir = catalogPath + "/OtherColors"
        setMockDirectory(at: otherColorsDir, with: ["more_colors", "greenColorHex.colorset"])
        setMockAsset(at: "\(otherColorsDir)/greenColorHex.colorset", with: ColorSetJSON.green)
        var greenColorHex: NamedColorSet = .greenColorHex
        greenColorHex.name = "OtherColors/greenColorHex"

        let moreColorsDir = otherColorsDir + "/more_colors"
        setMockDirectory(at: moreColorsDir, with: ["blueColorHex.colorset"])
        setMockAsset(at: "\(moreColorsDir)/blueColorHex.colorset", with: ColorSetJSON.blue)
        var blueColorHex: NamedColorSet = .blueColorHex
        blueColorHex.name = "OtherColors/more_colors/blueColorHex"

        // When
        let assets = try await sut.collectAssets(in: catalogPath)

        // Then
        XCTAssertEqual(assets, [greenColorHex, blueColorHex, .redColorHex])
    }
}

// MARK: - Private

extension AssetCollectorTests {
    private func setMockAsset(at path: String, with contentsJSON: String) {
        setMockDirectory(at: path, with: ["Contents.json"])
        setMockFile(at: "\(path)/Contents.json", with: data(contentsJSON))
    }

    private func setMockFile(at path: String, with content: Data?) {
        mocks.fileManager.results.fileExistsAtPath[path] = .file
        mocks.fileManager.results.contentsAtPath[path] = content
    }

    private func setMockDirectory(at path: String, with contents: [String]) {
        mocks.fileManager.results.fileExistsAtPath[path] = .directory
        mocks.fileManager.results.contentsOfDirectory[path] = .success(contents)
    }

    private func data(_ string: String) -> Data? {
        string.data(using: .utf8)
    }
}

// MARK: - Mocks

extension AssetCollectorTests {
    final class Mocks {
        var fileManager = FileManagerMock()
    }
}
