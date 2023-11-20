extension ColorAsset.Color {
    /// Supported color spaces (shown as "Content" in Attribute Inspector).
    enum ColorSpace: String, Decodable {
        case srgb
        case extendedSrgb = "extended-srgb"
        case extendedLinearSrgb = "extended-linear-srgb"
    }
}
