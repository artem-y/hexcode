import Foundation

// MARK: - ColorAsset.Color

extension ColorAsset {
    /// Representation of an actual color, containing components in a color space.
    struct Color: Decodable, Equatable {
        var colorSpace: ColorSpace
        var components: Components

        var rgbHex: String {
            let rgb = [
                components.red,
                components.green,
                components.blue
            ]

            return convert(rgb, from: .hex)
            ?? convert(rgb, from: .int)
            ?? convert(rgb, from: .float)
            ?? ""
        }

        enum CodingKeys: String, CodingKey {
            case components
            case colorSpace = "color-space"
        }
    }
}

// MARK: - Private

extension ColorAsset.Color {
    private func convert(_ components: [String], from rawComponentType: ComponentType) -> String? {
        let converter = switch rawComponentType {
        case .float: convertFloatToHexadecimal
        case .int: convertIntToHexadecimal
        case .hex: convertRawToHexadecimal
        }

        let hexComponents = components.compactMap(converter)
        guard hexComponents.count == 3 else { return nil }

        return hexComponents.joined()
    }

    private func convertRawToHexadecimal(_ component: String) -> String? {
        guard isValidHexComponent(component) else { return nil }
        return String(component.dropFirst(2))
    }

    private func isValidHexComponent(_ component: String) -> Bool {
        matchRegex(component, pattern: "0x[0-9a-fA-F]{2}")
    }

    private func matchRegex(_ string: String, pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let foundMatches = regex.matches(
            in: string,
            range: NSRange(
                location: 0,
                length: string.count
            )
        )
        return foundMatches.count == 1
    }

    private func convertIntToHexadecimal(_ component: String) -> String? {
        guard let intComponent = Int(component) else { return nil }
        return String(format: Self.hexFormatString, intComponent)
    }

    private func convertFloatToHexadecimal(_ component: String) -> String? {
        guard let nsNumberComponent = Self.formatter.number(from: component) else { return nil }

        let floatComponent = CGFloat(truncating: nsNumberComponent)
        guard floatComponent >= 0.0 && floatComponent <= 1.0 else { return nil }

        let intComponent = Int(floatComponent * Self.floatConversionMultiplier)
        return String(format: Self.hexFormatString, intComponent)
    }
}

// MARK: - Constants

extension ColorAsset.Color {
    private static let floatConversionMultiplier: CGFloat = 255.2
    private static let hexFormatString = "%02X"

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        return formatter
    }()
}

// MARK: - ColorAsset.Color.ComponentType

extension ColorAsset.Color {
    /// Convenience type to differentiate possible types of components.
    private enum ComponentType {
        case float
        case hex
        case int
    }
}
