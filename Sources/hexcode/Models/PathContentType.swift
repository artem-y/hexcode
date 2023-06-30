enum PathContentType {
    case colorSet(ColorSet)
    case file
    case otherDirectory(subpaths: [String])
}
