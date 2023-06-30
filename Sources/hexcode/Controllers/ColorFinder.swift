import Foundation

protocol ColorFinding {
    func find(_ hex: String, in colorSets: [NamedColorSet]) -> [String]
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

