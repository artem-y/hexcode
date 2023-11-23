/// Type of recognizable content at path in the file system.
enum PathContentType {
    /// Color set directory.
    case colorSet(ColorSet)
    /// File, not a directory.
    case file
    /// Some directory that isn't a color set.
    case otherDirectory(subpaths: [String])
}
