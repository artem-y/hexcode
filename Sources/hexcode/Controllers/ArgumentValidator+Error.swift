extension ArgumentValidator {
    /// Error when color hex input didn't match validation criteria.
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
        case .tooShort: "Color hex is too short"
        case .tooLong: "Color hex is too long"
        case .hasInvalidSymbols: "Color hex contains invalid symbols"
        }
    }
}
