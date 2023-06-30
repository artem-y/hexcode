import Foundation

extension ArgumentValidator {
    enum ColorHexError: Swift.Error, Equatable {
        case tooShort
        case tooLong
        case hasInvalidSymbols
    }
}

// MARK: - CustomStringConvertible

extension ArgumentValidator.ColorHexError: CustomStringConvertible {
    var description: String {
        switch self {
        case .tooShort:
            return "Color hex is too short"
        case .tooLong:
            return "Color hex is too long"
        case .hasInvalidSymbols:
            return "Color hex contains invalid symbols"
        }
    }
}
