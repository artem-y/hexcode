enum ColorSetJSON {
    static let white = makeColorSetJSON(red: "0xFF", green: "0xFF", blue: "0xFF")
    static let black = makeColorSetJSON(red: "0x00", green: "0x00", blue: "0x00")
    static let red = makeColorSetJSON(red: "0xFF", green: "0x00", blue: "0x00")
    static let green = makeColorSetJSON(red: "0x00", green: "0xFF", blue: "0x00")
    static let blue = makeColorSetJSON(red: "0x00", green: "0x00", blue: "0xFF")
}

// MARK: - Helpers

extension ColorSetJSON {
    private static func makeColorSetJSON(red: String, green: String, blue: String) -> String {
        """
        {
          "colors" : [
            {
              "color" : {
                "color-space" : "srgb",
                "components" : {
                  "alpha" : "1.000",
                  "blue" : "\(blue)",
                  "green" : "\(green)",
                  "red" : "\(red)"
                }
              },
              "idiom" : "universal"
            }
          ],
          "info" : {
            "author" : "xcode",
            "version" : 1
          }
        }
        """
    }
}
