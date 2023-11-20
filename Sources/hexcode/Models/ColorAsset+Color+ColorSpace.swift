extension ColorAsset.Color {
    enum ColorSpace: String, Decodable {
        case srgb
        case extendedSrgb = "extended-srgb"
        case extendedLinearSrgb = "extended-linear-srgb"
    }
}
