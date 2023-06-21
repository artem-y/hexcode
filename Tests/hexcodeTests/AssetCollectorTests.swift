//
//  AssetCollectorTests.swift
//  
//
//  Created by Artem Yelizarov on 20.06.2023.
//

@testable import hexcode
import XCTest

final class AssetCollectorTests: XCTestCase {
    typealias SUT = AssetCollector

    func test_collectAssets_inAssetCatalogDirectory_findsAssets() throws {
        // Given
        let sut = SUT()
        let assetCatalogPath = try XCTUnwrap(Bundle.module.resourcePath) + "/Resources/Assets.xcassets"

        // When
        let assets = try sut.collectAssets(in: assetCatalogPath)

        // Then
        XCTAssertEqual(assets, [.blackColorHex, .whiteColorHex])
    }

    func test_collectAssets_inDicectoryWithoutAssets_findsNothing() throws {
        // Given
        let sut = SUT()
        let path = try XCTUnwrap(Bundle.module.resourcePath) + "/Resources/FakeContentFolder"

        // When
        let assets = try sut.collectAssets(in: path)

        // Then
        XCTAssert(assets.isEmpty)
    }

    func test_collectAssets_inNonExistentDirectory_throwsDirectoryNotFoundError() throws {
        // Given
        let sut = SUT()
        let path = try XCTUnwrap(Bundle.module.resourcePath) + "/ImaginaryFolder"

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
        let sut = SUT()
        let path = try XCTUnwrap(Bundle.module.resourcePath) + "/Resources/EmptyFile"

        XCTAssertThrowsError(
            // When
            _ = try sut.collectAssets(in: path)
        ) { error in
            let error = error as? SUT.Error

            // Then
            XCTAssertEqual(error, .notADirectory)
        }
    }
}
