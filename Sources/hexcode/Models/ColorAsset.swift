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
