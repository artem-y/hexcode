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

                return makeColorName(from: appearances, of: namedSet)
            }
    }

    func findDuplicates(in colorSets: [NamedColorSet]) -> [String: [String]] {

        var duplicates: [String: [String]] = [:]
        let colorSetCount = colorSets.count

        for currentColorSetIndex in 0..<colorSetCount {
            let currentColorSet = colorSets[currentColorSetIndex]
            let currentColors = currentColorSet.colorSet.colors
            let nextColorSetIndex = currentColorSetIndex + 1

            for currentColor in currentColors {
                let rgbHex = currentColor.color.rgbHex

                if rgbHex.isEmpty || duplicates.keys.contains(rgbHex) {
                    continue
                }

                var colorNames: [String] = []

                for otherColorSet in colorSets[nextColorSetIndex...] {
                    let otherColorSetAppearances = findAppearances(
                        for: rgbHex,
                        in: otherColorSet.colorSet.colors
                    )

                    if otherColorSetAppearances.isEmpty {
                        continue
                    }

                    let name = makeColorName(
                        from: otherColorSetAppearances,
                        of: otherColorSet
                    )
                    colorNames.append(name)
                }

                // If at least one duplicate found, add the searched name too
                if !colorNames.isEmpty {
                    let currentColorSetAppearances = findAppearances(
                        for: rgbHex,
                        in: currentColors
                    )

                    let currentColorSetName = makeColorName(
                        from: currentColorSetAppearances,
                        of: currentColorSet
                    )
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

    private func makeColorName(from appearances: [String], of namedColorSet: NamedColorSet) -> String {
        if appearances.count < namedColorSet.colorSet.colors.count {
            return "\(namedColorSet.name) (\(joined(appearances)))"
        } else {
            return namedColorSet.name
        }
    }
}
