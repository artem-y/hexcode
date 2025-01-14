@testable import hexcode
import XCTest
import SwiftyTestAssertions

final class HexcodeAppTests: XCTestCase {
    typealias SUT = HexcodeApp

    private var mocks = Mocks()
    private lazy var sut = makeSUT()

    private let blackHexStub = "#000000"

    // MARK: - Life Cycle

    override func setUp() {
        mocks = Mocks()
        sut = makeSUT()
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

    // MARK: - Test runFindColor

    func test_runFindColor_withoutDirectory_runsInCurrentDirectoryFromFileManager() async throws {
        // Given
        let currentDirectory = "/currentDirectory"
        mocks.fileManager.results.currentDirectoryPath = currentDirectory

        // When
        try await sut.runFindColor(colorHex: "")

        // Then
        XCTAssertEqual(mocks.fileManager.calls, [.getCurrentDirectoryPath])
        XCTAssertEqual(mocks.assetCollector.calls, [.collectAssetsIn(directory: currentDirectory)])
    }

    func test_runFindColor_inDirectory_runsInProvidedDirectory() async throws {
        // Given
        let searchDirectory = "/searchDirectory"

        // When
        try await sut.runFindColor(colorHex: "", in: searchDirectory)

        // Then
        XCTAssertEqual(mocks.assetCollector.calls, [.collectAssetsIn(directory: searchDirectory)])
    }

    func test_runFindColor_whenAssetCollectorThrowsNotADirectoryError_rethrowsError() async throws {
        // Given
        mocks.assetCollector.results.collectAssets = .failure(AssetCollector.Error.notADirectory)

        await AssertAsync(
            try await sut.runFindColor(colorHex: blackHexStub), // When
            throwsError: AssetCollector.Error.notADirectory // Then
        )
    }

    func test_runFindColor_whenAssetCollectorThrowsDirectoryNotFound_rethrowsError() async throws {
        // Given
        mocks.assetCollector.results.collectAssets = .failure(AssetCollector.Error.directoryNotFound)

        await AssertAsync(
            try await sut.runFindColor(colorHex: blackHexStub), // When
            throwsError: AssetCollector.Error.directoryNotFound // Then
        )
    }

    func test_runFindColor_whenAssetCollectorThrowsNotADirectoryError_doesNotLookForColors() async {
        // Given
        mocks.assetCollector.results.collectAssets = .failure(AssetCollector.Error.notADirectory)

        // When
        try? await sut.runFindColor(colorHex: blackHexStub)

        // Then
        AssertEmpty(mocks.colorFinder.calls)
        AssertEmpty(mocks.outputs)
    }

    func test_runFindColor_whenAssetCollectorThrowsDirectoryNotFound_doesNotLookForColors() async {
        // Given
        mocks.assetCollector.results.collectAssets = .failure(AssetCollector.Error.directoryNotFound)

        // When
        try? await sut.runFindColor(colorHex: blackHexStub)

        // Then
        AssertEmpty(mocks.colorFinder.calls)
        AssertEmpty(mocks.outputs)
    }

    func test_runFindColor_whenCollectedAssets_callsColorFinderWithCollectedAssets() async throws {
        // Given
        let expectedColorSets: [NamedColorSet] = [
            .blueColorHex,
            .greenColorHex,
            .redColorHex,
        ]
        let colorHex = "123456"
        mocks.assetCollector.results.collectAssets = .success(expectedColorSets)

        // When
        try await sut.runFindColor(colorHex: colorHex)

        // Then
        XCTAssertEqual(
            mocks.colorFinder.calls,
            [.find(hex: colorHex, colorSets: expectedColorSets)]
        )
    }

    func test_runFindColor_whenDidNotCollectAssets_callsColorFinderWithEmptyArray() async throws {
        // Given
        let colorHex = "#F1F2F3"
        mocks.assetCollector.results.collectAssets = .success([])

        // When
        try await sut.runFindColor(colorHex: colorHex)

        // Then
        XCTAssertEqual(
            mocks.colorFinder.calls,
            [.find(hex: colorHex, colorSets: [])]
        )
    }

    func test_runFindColor_whenSingleColorAssetIsFound_outputsAssetName() async throws {
        // Given
        let expectedOutput = "white"
        mocks.colorFinder.results.find = [expectedOutput]

        // When
        try await sut.runFindColor(colorHex: "")

        // Then
        XCTAssertEqual(mocks.outputs, [expectedOutput])
    }

    func test_runFindColor_whenMultipleColorAssetIsFound_outputsAllAssetNames() async throws {
        // Given
        let expectedOutputs = ["red", "green", "blue"]
        mocks.colorFinder.results.find = expectedOutputs

        // When
        try await sut.runFindColor(colorHex: "")

        // Then
        XCTAssertEqual(mocks.outputs, expectedOutputs)
    }

    func test_runFindColor_whenNoColorAssetsFound_outputsNoColorsFoundMessage() async throws {
        // Given
        mocks.colorFinder.results.find = []

        // When
        try await sut.runFindColor(colorHex: blackHexStub)

        // Then
        XCTAssertEqual(mocks.outputs, ["No \(blackHexStub) color found"])
    }

    func test_runFindColor_withTildeInPath_expandsTildaToFilePath() async throws {
        // Given
        let homeDir = "/home/dir"
        let homeURL = try XCTUnwrap(URL(filePath: homeDir))
        mocks.fileManager.results.homeDirectoryForCurrentUser = homeURL

        // When
        try await sut.runFindColor(colorHex: blackHexStub, in: "~/TestProject")


        // Then
        XCTAssertEqual(mocks.fileManager.calls, [
            .getHomeDirectoryForCurrentUser
        ])
        XCTAssertEqual(mocks.assetCollector.calls, [
            .collectAssetsIn(directory: "\(homeDir)/TestProject")
        ])
    }

    // MARK: Test runFindDuplicates

    func test_runFindDuplicates_whenSingleDuplicateFound_outputsDuplicateHexAndAssetNames() async throws {
        // Given
        mocks.colorFinder.results.findDuplicates = ["000000": ["snowWhite", "white"]]

        // When
        try await sut.runFindDuplicates()

        // Then
        XCTAssertEqual(mocks.outputs, [
            "#000000 snowWhite",
            "#000000 white",
        ])
    }

    func test_runFindDuplicates_whenNoDuplicateFound_outputsNoDuplicatesFoundMessage() async throws {
        // Given
        mocks.colorFinder.results.findDuplicates = [:]

        // When
        try await sut.runFindDuplicates()

        // Then
        XCTAssertEqual(mocks.outputs, ["No duplicates found"])
    }

    func test_runFindDuplicates_whenMultipleDuplicatesFound_outputsDuplicatesWithSeparator() async throws {
        // Given
        mocks.colorFinder.results.findDuplicates = [
            "FF00FF": ["magenta", "accentColor"],
            "000000": ["snowWhite", "white"],
            "FFFFFF": ["black", "darkestHex", "text (Any, Light)"]
        ]

        // When
        try await sut.runFindDuplicates()

        // Then
        XCTAssertEqual(mocks.outputs, [
            "#000000 snowWhite",
            "#000000 white",
            "--",
            "#FF00FF magenta",
            "#FF00FF accentColor",
            "--",
            "#FFFFFF black",
            "#FFFFFF darkestHex",
            "#FFFFFF text (Any, Light)",
        ])
    }

    func test_runFindDuplicates_withTildeInPath_expandsTildaToFilePath() async throws {
        // Given
        let homeDir = "/Users/user"
        let homeURL = try XCTUnwrap(URL(string: homeDir))
        mocks.fileManager.results.homeDirectoryForCurrentUser = homeURL

        // When
        try await sut.runFindDuplicates(in: "~/documents/project")


        // Then
        XCTAssertEqual(mocks.fileManager.calls, [
            .getHomeDirectoryForCurrentUser
        ])
        XCTAssertEqual(mocks.assetCollector.calls, [
            .collectAssetsIn(directory: "\(homeDir)/documents/project")
        ])
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
