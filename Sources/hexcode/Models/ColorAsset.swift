/// Representation of topmost single color variation object inside colorset.
/// One of the color variations within a color set.
struct ColorAsset: Decodable, Equatable {
    var color: Color
    var idiom: Idiom
    var appearances: [Appearance]?
    var subtype: String?
}

// MARK: - ColorAsset.Idiom

extension ColorAsset {
    /// Color `idiom` variations (`Devices`)
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
    /// Color variations based on appearance.
    struct Appearance: Decodable, Equatable {
        var appearance: String
        var value: String
    }
}
