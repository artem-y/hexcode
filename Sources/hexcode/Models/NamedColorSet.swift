/// Color set content representation with associated directory name.
struct NamedColorSet: Decodable, Equatable {
    var name: String
    var colorSet: ColorSet
}
