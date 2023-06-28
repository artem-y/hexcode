import Foundation

struct NamedColorSet: Decodable, Equatable {
    var name: String
    var colorSet: ColorSet
}
