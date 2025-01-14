@testable import hexcode
import Foundation

enum PathContent {
    case file
    case directory
}

final class FileManagerMock: FileManager {
    enum Call: Equatable {
        case getCurrentDirectoryPath
        case setCurrentDirectoryPath(String)
        case getHomeDirectoryForCurrentUser
        case fileExists(path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?)
        case contentsOfDirectory(path: String)
        case contents(path: String)
    }

    struct CallResults {
        var currentDirectoryPath: String = ""
        var homeDirectoryForCurrentUser: URL = .init(filePath: "")
        var fileExistsAtPath: [String: PathContent] = [:]
        var contentsOfDirectory: [String: Result<[String], Error>] = [:]
        var contentsAtPath: [String: Data] = [:]
    }

    private(set) var calls: [Call] {
        get {
            callsLock.lock()
            defer { callsLock.unlock() }
            return _calls
        }
        set {
            callsLock.lock()
            defer { callsLock.unlock() }
            _calls = newValue
        }
    }

    var results = CallResults()

    private let callsLock = NSLock()
    private var _calls: [Call] = []

    func reset() {
        calls = []
        results = .init()
    }
}

// MARK: - FileManager

extension FileManagerMock {
    override var currentDirectoryPath: String {
        get {
            calls.append(.getCurrentDirectoryPath)
            return results.currentDirectoryPath
        }

        set {
            calls.append(.setCurrentDirectoryPath(newValue))
        }
    }

    override var homeDirectoryForCurrentUser: URL {
        get {
            calls.append(.getHomeDirectoryForCurrentUser)
            return results.homeDirectoryForCurrentUser
        }
    }

    override func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        calls.append(.fileExists(path: path, isDirectory: isDirectory))
        guard let pathContent = results.fileExistsAtPath[path] else { return false }
        if let isDirectory {
            isDirectory.pointee = ObjCBool(pathContent == .directory)
        }
        return true
    }

    override func contentsOfDirectory(atPath path: String) throws -> [String] {
        calls.append(.contentsOfDirectory(path: path))
        let contentsOfDirectory = try results.contentsOfDirectory[path]?.get()
        return contentsOfDirectory ?? []
    }

    override func contents(atPath path: String) -> Data? {
        calls.append(.contents(path: path))
        return results.contentsAtPath[path]
    }
}
