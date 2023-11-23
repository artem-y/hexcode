extension ColorAsset.Color {
    /// Raw rgba color components.
    struct Components: Decodable, Equatable {
        var alpha: String
        var red: String
        var green: String
        var blue: String
    }
}
