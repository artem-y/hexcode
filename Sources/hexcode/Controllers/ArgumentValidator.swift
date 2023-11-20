/// Validates input arguments.
struct ArgumentValidator {
    /// Validates color hex input argument. Input is valid if no error was thrown.
    /// - parameter colorHex: Hexadecimal color code.
    /// - returns: `Void`, meaning input is valid.
    /// - throws: Validation errors, meaning input is invalid.
    func validate(colorHex: String) throws {
        var colorHex = colorHex
        if colorHex.first == "#" {
            colorHex.removeFirst()
        }

        let characterCount = colorHex.count
        if characterCount > Constant.supportedHexCharCount {
            throw ColorHexError.tooLong
        }
        if characterCount < Constant.supportedHexCharCount {
            throw ColorHexError.tooShort
        }

        if containsInvalidSymbols(colorHex.uppercased()) {
            throw ColorHexError.hasInvalidSymbols
        }
    }
}

// MARK: - Private

extension ArgumentValidator {
    private func containsInvalidSymbols(_ colorHex: String) -> Bool {
        !colorHex.allSatisfy(Constant.supportedHexSymbols.contains)
    }
}

// MARK: - Constants

extension ArgumentValidator {
    private enum Constant {
        static let supportedHexCharCount = 6
        static let supportedHexSymbols = "0123456789ABCDEF"
    }
}
