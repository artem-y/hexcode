/// Finds matching color(s).
protocol ColorFinding {
    /// Searches the collection of named color sets for colors with matching hex equivalent.
    /// - parameter hex: Hexadecimal color code to find in color set collection.
    /// - parameter colorSets: Color sets to check for matching hex color code.
    /// - returns: Names of color sets with matching colors. Empty if none found.
    func find(_ hex: String, in colorSets: [NamedColorSet]) -> [String]


    /// Searches the collection of named color sets for colors matching the same hex equivalent.
    /// - Parameter colorSets: Color sets to check for duplicate hex values.
    /// - Returns: Hexadecimal color codes with arrays of matching color duplicates. Empty if none found.
    func findDuplicates(in colorSets: [NamedColorSet]) -> [String: [String]]
}

final class ColorFinder: ColorFinding {
    func find(_ hex: String, in colorSets: [NamedColorSet]) -> [String] {
        let hex = hex
            .trimmingCharacters(in: ["#"])
            .uppercased()

        return colorSets
            .compactMap { namedSet in
                let colors = namedSet.colorSet.colors
                let appearances = findAppearances(for: hex, in: colors)

                guard !appearances.isEmpty else {
                    return nil
                }
                guard appearances.count < colors.count else {
                    return namedSet.name
                }

                return namedSet.name + " (\(joined(appearances)))"
            }
    }

    func findDuplicates(in colorSets: [NamedColorSet]) -> [String: [String]] {

        var duplicates: [String: [String]] = [:]
        let lastColorSetIndex = colorSets.count - 1

        for currentColorSetIndex in 0...lastColorSetIndex {
            let colorSet = colorSets[currentColorSetIndex]
            let colors = colorSet.colorSet.colors
            let nextIndex = currentColorSetIndex + 1

            for color in colors {
                let rgbHex = color.color.rgbHex

                if duplicates.keys.contains(rgbHex) {
                    continue
                }
                
                var colorNames: [String] = []

                for otherColor in colorSets[nextIndex...] {
                    let appearanceNames = findAppearances(
                        for: rgbHex,
                        in: otherColor.colorSet.colors
                    )

                    if appearanceNames.isEmpty {
                        continue
                    }

                    var name = otherColor.name

                    if appearanceNames.count < otherColor.colorSet.colors.count {
                        name += " (\(joined(appearanceNames)))"
                    }

                    colorNames.append(name)
                }

                if !colorNames.isEmpty {
                    let currentColorSetAppearances = findAppearances(
                        for: rgbHex,
                        in: colors
                    )
                    
                    if currentColorSetAppearances.isEmpty {
                        break
                    }

                    var currentColorSetName = colorSet.name

                    if currentColorSetAppearances.count < colors.count {
                        currentColorSetName += " (\(joined(currentColorSetAppearances)))"
                    }

                    colorNames.append(currentColorSetName)

                    if duplicates[rgbHex] == nil {
                        duplicates[rgbHex] = colorNames.sorted()
                    }
                }

            }
        }

        return duplicates
    }
}

// MARK: - Private

extension ColorFinder {
    private func findAppearances(
        for hex: String,
        in colorAssets: [ColorAsset]
    ) -> [String] {

        colorAssets
            .compactMap { asset in
                guard asset.color.rgbHex == hex else {
                    return nil
                }
                guard let appearances = asset.appearances else {
                    return "Any"
                }

                let appearanceNames = appearances
                    .map(\.value.capitalized)
                    .sorted()

                return joined(appearanceNames)
            }
            .sorted()
    }

    private func joined(_ appearances: [String]) -> String {
        appearances.joined(separator: ", ")
    }
}
