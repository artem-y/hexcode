import Foundation
import Cocoa

struct ColorAsset: Decodable, Equatable {
    var color: Color
    var idiom: Idiom
    var appearances: [Appearance]?
    var subtype: String?
}

// MARK: - ColorAsset.Idiom

extension ColorAsset {
    enum Idiom: String, Decodable {
        case universal
        case iPhone = "iphone"
        case iPad = "ipad"
        case car
        case mac
        case watch
        case tv
    }
}

// MARK: - ColorAsset.Appearance

extension ColorAsset {
    struct Appearance: Decodable, Equatable {
        var appearance: String
        var value: String
    }
}

// MARK: - ColorAsset.Color

extension ColorAsset {
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
        return String(format: "%02X", intComponent)
    }

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        return formatter
    }()

    private func convertFloatToHexadecimal(_ component: String) -> String? {
        guard let nsNumberComponent = Self.formatter.number(from: component) else { return nil }

        let floatComponent = CGFloat(truncating: nsNumberComponent)
        guard floatComponent >= 0.0 && floatComponent <= 1.0 else { return nil }

        let intComponent = Int(floatComponent * 255.0)
        return String(format: "%02X", intComponent)
    }
}

// MARK: - ColorAsset.Color.ColorSpace

extension ColorAsset.Color {
    enum ColorSpace: String, Decodable {
        case srgb
        case extendedSrgb = "extended-srgb"
        case extendedLinearSrgb = "extended-linear-srgb"
    }
}

// MARK: - ColorAsset.Color.Components

extension ColorAsset.Color {
    struct Components: Decodable, Equatable {
        var alpha: String
        var red: String
        var green: String
        var blue: String
    }
}

// MARK: - ColorAsset.Color.ComponentType

extension ColorAsset.Color {
    private enum ComponentType {
        case float
        case hex
        case int
    }
}
