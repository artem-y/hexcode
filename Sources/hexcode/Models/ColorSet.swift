import Foundation

struct ColorSet: Decodable, Equatable {
    struct Info: Decodable, Equatable {
        var author: String
        var version: Double
    }

    var colors: [ColorAsset]
    var info: Info
}
