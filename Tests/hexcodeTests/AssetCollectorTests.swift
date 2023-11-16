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

    func test_collectAssets_inAssetCatalogDirectory_findsAssets() throws {
        // Given
        let catalogPath = "Assets.xcassets"
        setMockDirectory(at: catalogPath, with: ["whiteColorHex.colorset", "blackColorHex.colorset"])
        setMockAsset(at: catalogPath + "/whiteColorHex.colorset", with: ColorSetJSON.white)
        setMockAsset(at: catalogPath + "/blackColorHex.colorset", with: ColorSetJSON.black)

        // When
        let assets = try sut.collectAssets(in: catalogPath)

        // Then
        XCTAssertEqual(assets, [.blackColorHex, .whiteColorHex])
    }

    func test_collectAssets_inDicectoryWithInvalidAssets_findsNothing() throws {
        // Given
        let directory = "/some/directory"

        setMockDirectory(at: directory, with: ["Contents.json", "notAColor.colorset", "brokenColor.colorset"])

        setMockFile(at: "\(directory)/Contents.json", with: data("{\"contents\": \"nope\"}"))

        setMockAsset(at: "\(directory)/brokenColor.colorset", with: "{\"color\": \"magenta\"}")

        setMockDirectory(at: "\(directory)/notAColor.colorset", with: ["text.txt"])
        setMockFile(at: "\(directory)/notAColor.colorset/text.txt", with: data("hello world"))

        // When
        let assets = try sut.collectAssets(in: directory)

        // Then
        AssertEmpty(assets, "not empty", file: #file, line: #line)
    }

    func test_collectAssets_inNonExistentDirectory_throwsDirectoryNotFoundError() throws {
        // Given
        let path = "/nonExistentDirectory"
        mocks.fileManager.results.fileExistsAtPath[path] = nil

        Assert(
            try sut.collectAssets(in: path), // When
            throwsError: SUT.Error.directoryNotFound // Then
        )
    }

    func test_collectAssets_atPathThatIsFile_throwsNotADirectoryError() throws {
        // Given
        let filePath = "/someFile"
        mocks.fileManager.results.fileExistsAtPath[filePath] = .file

        Assert(
            try sut.collectAssets(in: filePath), // When
            throwsError: SUT.Error.notADirectory // Then
        )
    }

    func test_collectAssets_inCatalogWithMultipleSubdirectories_findsAllAssets() throws {
        // Given
        let catalogPath = "/Resources/AssetsInSubdirectories.xcassets"
        setMockDirectory(at: catalogPath, with: ["OtherColors", "redColorHex.colorset",])
        setMockAsset(at: "\(catalogPath)/redColorHex.colorset", with: ColorSetJSON.red)

        let otherColorsDir = catalogPath + "/OtherColors"
        setMockDirectory(at: otherColorsDir, with: ["more_colors", "greenColorHex.colorset"])
        setMockAsset(at: "\(otherColorsDir)/greenColorHex.colorset", with: ColorSetJSON.green)

        let moreColorsDir = otherColorsDir + "/more_colors"
        setMockDirectory(at: moreColorsDir, with: ["blueColorHex.colorset"])
        setMockAsset(at: "\(moreColorsDir)/blueColorHex.colorset", with: ColorSetJSON.blue)

        // When
        let assets = try sut.collectAssets(in: catalogPath)

        // Then
        XCTAssertEqual(assets, [.blueColorHex, .greenColorHex, .redColorHex])
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
