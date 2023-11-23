/// Partial representation of `Contents.json` in `*.colorset` directory.
/// It is only detailed enough for the purposes of this app.
struct ColorSet: Decodable, Equatable {
    struct Info: Decodable, Equatable {
        var author: String
        var version: Double
    }

    var colors: [ColorAsset]
    var info: Info
}
