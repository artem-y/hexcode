import XCTest

extension XCTestCase {
    func makeResourcePath() throws -> String {
        let bundleResourcePath = try XCTUnwrap(Bundle.module.resourcePath)
        let resourcesSubdirectory = bundleResourcePath.appending("/Resources")

        if FileManager.default.fileExists(atPath: resourcesSubdirectory) {
            return resourcesSubdirectory
        } else {
            return bundleResourcePath
        }
    }
}
