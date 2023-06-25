//
//  AssetCollectorTests.swift
//  
//
//  Created by Artem Yelizarov on 20.06.2023.
//

@testable import hexcode
import XCTest
import Foundation

final class AssetCollectorTests: XCTestCase {
    typealias SUT = AssetCollector

    private var mocks = Mocks()

    // MARK: - Life Cycle

    override func setUpWithError() throws {
        mocks = Mocks()
    }

    // MARK: - Tests

    func test_collectAssets_inAssetCatalogDirectory_findsAssets() throws {
        // Given
        let sut = makeSUT()
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
        let sut = makeSUT()
        let directory = "/some/directory"

        setMockDirectory(at: directory, with: ["Contents.json", "notAColor.colorset", "brokenColor.colorset"])

        setMockFile(at: "\(directory)/Contents.json", with: data("{\"contents\": \"nope\"}"))

        setMockAsset(at: "\(directory)/brokenColor.colorset", with: "{\"color\": \"magenta\"}")

        setMockDirectory(at: "\(directory)/notAColor.colorset", with: ["text.txt"])
        setMockFile(at: "\(directory)/notAColor.colorset/text.txt", with: data("hello world"))

        // When
        let assets = try sut.collectAssets(in: directory)

        // Then
        XCTAssert(assets.isEmpty)
    }

    func test_collectAssets_inNonExistentDirectory_throwsDirectoryNotFoundError() throws {
        // Given
        let sut = makeSUT()
        let path = "/nonExistentDirectory"
        mocks.fileManager.results.fileExistsAtPath[path] = nil

        XCTAssertThrowsError(
            // When
            _ = try sut.collectAssets(in: path)
        ) { error in
            let error = error as? SUT.Error

            // Then
            XCTAssertEqual(error, .directoryNotFound)
        }
    }

    func test_collectAssets_atPathThatIsFile_throwsNotADirectoryError() throws {
        // Given
        let sut = makeSUT()
        let filePath = "/someFile"
        mocks.fileManager.results.fileExistsAtPath[filePath] = .file

        XCTAssertThrowsError(
            // When
            _ = try sut.collectAssets(in: filePath)
        ) { error in
            let error = error as? SUT.Error

            // Then
            XCTAssertEqual(error, .notADirectory)
        }
    }

    func test_collectAssets_inCatalogWithMultipleSubdirectories_findsAllAssets() throws {
        // Given
        let sut = makeSUT()

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
    private func makeSUT() -> SUT {
        let sut = SUT()
        sut.fileManager = mocks.fileManager
        return sut
    }

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
