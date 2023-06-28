//
//  HexcodeAppTests.swift
//  
//
//  Created by Artem Yelizarov on 24.06.2023.
//

@testable import hexcode
import XCTest

final class HexcodeAppTests: XCTestCase {
    typealias SUT = HexcodeApp

    private var mocks = Mocks()

    private let blackHexStub = "#000000"

    // MARK: - Life Cycle

    override func setUp() {
        mocks = Mocks()
    }

    // MARK: - Test init

    func test_init_withoutFileManager_passesDefaultFileManagerIntoAssetCollector() {
        // When
        _ = SUT(assetCollector: mocks.assetCollector)

        // Then
        XCTAssertEqual(mocks.assetCollector.calls, [.setFileManager(.default)])
    }

    func test_init_passingFileManager_passesDefaultFileManagerIntoAssetCollector() {
        // When
        _ = SUT(fileManager: mocks.fileManager, assetCollector: mocks.assetCollector)

        // Then
        XCTAssertEqual(mocks.assetCollector.calls, [.setFileManager(mocks.fileManager)])
    }

    // MARK: - Test run

    func test_run_withoutDirectory_runsInCurrentDirectoryFromFileManager() throws {
        // Given
        let sut = makeSUT()
        let currentDirectory = "/currentDirectory"
        mocks.fileManager.results.currentDirectoryPath = currentDirectory

        // When
        try sut.run(colorHex: "")

        // Then
        XCTAssertEqual(mocks.fileManager.calls, [.getCurrentDirectoryPath])
        XCTAssertEqual(mocks.assetCollector.calls, [.collectAssetsIn(directory: currentDirectory)])
    }

    func test_run_inDirectory_runsInProvidedDirectory() throws {
        // Given
        let sut = makeSUT()
        let searchDirectory = "/searchDirectory"

        // When
        try sut.run(colorHex: "", in: searchDirectory)

        // Then
        XCTAssertEqual(mocks.assetCollector.calls, [.collectAssetsIn(directory: searchDirectory)])
    }

    func test_run_whenAssetCollectorThrowsNotADirectoryError_rethrowsError() throws {
        // Given
        let sut = makeSUT()
        mocks.assetCollector.results.collectAssets = .failure(AssetCollector.Error.notADirectory)

        Assert(
            try sut.run(colorHex: blackHexStub), // When
            throwsError: AssetCollector.Error.notADirectory // Then
        )
    }

    func test_run_whenAssetCollectorThrowsDirectoryNotFound_rethrowsError() throws {
        // Given
        let sut = makeSUT()
        mocks.assetCollector.results.collectAssets = .failure(AssetCollector.Error.directoryNotFound)

        Assert(
            try sut.run(colorHex: blackHexStub), // When
            throwsError: AssetCollector.Error.directoryNotFound // Then
        )
    }

    func test_run_whenAssetCollectorThrowsNotADirectoryError_doesNotLookForColors() {
        // Given
        let sut = makeSUT()
        mocks.assetCollector.results.collectAssets = .failure(AssetCollector.Error.notADirectory)

        // When
        try? sut.run(colorHex: blackHexStub)

        // Then
        XCTAssert(mocks.colorFinder.calls.isEmpty)
        XCTAssert(mocks.outputs.isEmpty)
    }

    func test_run_whenAssetCollectorThrowsDirectoryNotFound_doesNotLookForColors() {
        // Given
        let sut = makeSUT()
        mocks.assetCollector.results.collectAssets = .failure(AssetCollector.Error.directoryNotFound)

        // When
        try? sut.run(colorHex: blackHexStub)

        // Then
        XCTAssert(mocks.colorFinder.calls.isEmpty)
        XCTAssert(mocks.outputs.isEmpty)
    }

    func test_run_whenCollectedAssets_callsColorFinderWithCollectedAssets() throws {
        // Given
        let sut = makeSUT()
        let expectedColorSets: [NamedColorSet] = [
            .blueColorHex,
            .greenColorHex,
            .redColorHex,
        ]
        let colorHex = "123456"
        mocks.assetCollector.results.collectAssets = .success(expectedColorSets)

        // When
        try sut.run(colorHex: colorHex)

        // Then
        XCTAssertEqual(
            mocks.colorFinder.calls,
            [.find(hex: colorHex, colorSets: expectedColorSets)]
        )
    }

    func test_run_whenDidNotCollectAssets_callsColorFinderWithEmptyArray() throws {
        // Given
        let sut = makeSUT()
        let colorHex = "#F1F2F3"
        mocks.assetCollector.results.collectAssets = .success([])

        // When
        try sut.run(colorHex: colorHex)

        // Then
        XCTAssertEqual(
            mocks.colorFinder.calls,
            [.find(hex: colorHex, colorSets: [])]
        )
    }

    func test_run_whenSingleColorAssetIsFound_outputsAssetName() throws {
        // Given
        let sut = makeSUT()
        let expectedOutput = "white"
        mocks.colorFinder.results.find = [expectedOutput]

        // When
        try sut.run(colorHex: "")

        // Then
        XCTAssertEqual(mocks.outputs, [expectedOutput])
    }

    func test_run_whenMultipleColorAssetIsFound_outputsAllAssetNames() throws {
        // Given
        let sut = makeSUT()
        let expectedOutputs = ["red", "green", "blue"]
        mocks.colorFinder.results.find = expectedOutputs

        // When
        try sut.run(colorHex: "")

        // Then
        XCTAssertEqual(mocks.outputs, expectedOutputs)
    }

    func test_run_whenNoColorAssetsFound_outputsNoColorsFoundMessage() throws {
        // Given
        let sut = makeSUT()
        mocks.colorFinder.results.find = []

        // When
        try sut.run(colorHex: blackHexStub)

        // Then
        XCTAssertEqual(mocks.outputs, ["No \(blackHexStub) color found"])
    }
}

// MARK: - Private

extension HexcodeAppTests {
    private func makeSUT() -> SUT {
        let sut = SUT(
            fileManager: mocks.fileManager,
            assetCollector: mocks.assetCollector,
            colorFinder: mocks.colorFinder,
            outputFunction: mocks.output
        )

        mocks.fileManager.reset()
        mocks.assetCollector.reset()
        mocks.colorFinder.reset()

        return sut
    }
}

// MARK: - Mocks

extension HexcodeAppTests {
    final class Mocks {
        var assetCollector = AssetCollectorMock()
        var fileManager = FileManagerMock()
        var colorFinder = ColorFinderMock()

        private(set) var outputs: [String] = []

        func output(_ string: String) {
            outputs.append(string)
        }
    }
}