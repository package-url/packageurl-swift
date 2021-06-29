import Foundation

/**
 A package URL, or _purl_, is a URL string used to identify and locate a software package
 in a mostly universal and uniform way across
 programing languages, package managers, packaging conventions, tools, APIs and databases.

 A purl is a URL composed of seven components:

 ```
 scheme:type/namespace/name@version?qualifiers#subpath
 ```

 For example,
 the package URL for this Swift package at version 0.0.1 is
 `pkg:swift/mattt/packageurl-swift@0.0.1`.
 */
public struct PackageURL: Hashable {
    /// The URL scheme, which has a constant value of `"pkg"`.
    public let scheme: String = "pkg"

    /// The package type or protocol, such as `"swift"`, `"npm"`, and `"github"`.
    public let type: String

    /// A name prefix, specific to the type of package.
    /// For example, a Swift package scope, a Docker image owner, or a GitHub user.
    public let namespace: String?

    /// The name of the package.
    public let name: String

    /// The version of the package.
    public let version: String?

    /// Extra qualifying data for a package, specific to the type of package.
    /// For example, the operating system or architecture.
    public let qualifiers: [String: String]?

    /// An extra subpath within a package, relative to the package root.
    public let subpath: String?

    /// Creates a new package URL with the specified components.
    /// - Parameters:
    ///   - type: The package type.
    ///   - namespace: The package namespace, if any.
    ///   - name: The package name.
    ///   - version: The package version, if any.
    ///   - qualifiers: Any additional information specific to the type of package.
    ///   - subpath: The subpath within the package, if any.
    public init(type: String,
                namespace: String?,
                name: String,
                version: String?,
                qualifiers: [String: String]? = nil,
                subpath: String? = nil)
    {
        self.type = type
        self.namespace = namespace
        self.name = name
        self.version = version
        self.qualifiers = qualifiers
        self.subpath = subpath
    }

    init(_ purl: PackageURL) {
        self.init(type: purl.type,
                  namespace: purl.namespace,
                  name: purl.name,
                  version: purl.version,
                  qualifiers: purl.qualifiers,
                  subpath: purl.subpath)
    }
}

// MARK: - LosslessStringConvertible

extension PackageURL: LosslessStringConvertible {
    /**
     Creates a new package URL from a string representation.

     - Parameter string: A string containing a package URL.
     - Returns: A package URL, or `nil` if the string is invalid.

     - Remark: Package URLs are parsed according to the instructions provided at
               [PURL-SPECIFICATION.rst](https://github.com/package-url/purl-spec/blob/0b1559f76b79829e789c4f20e6d832c7314762c5/PURL-SPECIFICATION.rst#how-to-parse-a-purl-string-in-its-components).
     */
    public init?(_ string: String) {
        var string = string[...]

        /*
         Split the purl string once from right on '#'
         - The left side is the remainder
         - Strip the right side from leading and trailing '/'
         - Split this on '/'
         - Discard any empty string segment from that split
         - Discard any '.' or '..' segment from that split
         - Percent-decode each segment
         - UTF-8-decode each segment if needed in your programming language
         - Join segments back with a '/'
         - This is the subpath
         */
        if let subpathDelimiterIndex = string.lastIndex(of: "#") {
            let (remainder, subpath) = string.split(at: subpathDelimiterIndex)
            self.subpath = subpath.split(separator: "/", omittingEmptySubsequences: true)
                                  .filter { segment in segment.isValidSubpathSegment }
                                  .compactMap { segment in segment.removingPercentEncoding }
                                  .joined(separator: "/")

            string = remainder
        } else {
            self.subpath = nil
        }

        /*
         Split the remainder once from right on '?'
         - The left side is the remainder
         - The right side is the qualifiers string
         - Split the qualifiers on '&'. Each part is a key=value pair
         - For each pair, split the key=value once from left on '=':
         - The key is the lowercase left side
         - The value is the percent-decoded right side
         - UTF-8-decode the value if needed in your programming language
         - Discard any key/value pairs where the value is empty
         - If the key is checksums, split the value on ',' to create a list of checksums
         - This list of key/value is the qualifiers object
         */
        if let qualifiersDelimiterIndex = string.lastIndex(of: "?") {
            let (remainder, qualifiers) = string.split(at: qualifiersDelimiterIndex)
            let keyValuePairs: [(key: String, value: String)] = qualifiers.split(separator: "&", omittingEmptySubsequences: true)
                                          .compactMap { part in
                                              let pair = part.split(separator: "=", maxSplits: 2)
                                              guard pair.count == 2,
                                                    let key = pair.first?.removingPercentEncoding?.lowercased(),
                                                    let value = pair.last?.removingPercentEncoding
                                              else {
                                                  return nil
                                              }

                                              return (key, value)
                                          }

            for case let (key, _) in keyValuePairs {
                guard key.allSatisfy({ $0.isASCII && !$0.isWhitespace }) else {
                    return nil
                }
            }

            self.qualifiers = Dictionary(keyValuePairs, uniquingKeysWith: { _, last in last })

            string = remainder
        } else {
            self.qualifiers = nil
        }

        /*
         Split the remainder once from left on ':'
         - The left side lowercased is the scheme
         - The right side is the remainder
         */
        if let schemeDelimiterIndex = string.firstIndex(of: ":") {
            var (scheme, remainder) = string.split(at: schemeDelimiterIndex)
            guard scheme.lowercased() == "pkg" else { return nil }

            // purl parsers must accept URLs such as 'pkg://' and must ignore the '//'.
            if remainder.starts(with: "//") {
                remainder.removeFirst(2)
            }

            string = remainder
        } else {
            return nil
        }

        /*
         Strip the remainder from leading and trailing '/'
         - Split this once from left on '/'
         - The left side lowercased is the type
         - The right side is the remainder
         */
        string = string.drop(while: { $0 == "/" })
        if let typeDelimiterIndex = string.firstIndex(of: "/") {
            let (type, remainder) = string.split(at: typeDelimiterIndex)
            self.type = type.lowercased()

            string = remainder
        } else {
            return nil
        }

        /*
         Split the remainder once from right on '@'
         - The left side is the remainder
         - Percent-decode the right side. This is the version.
         - UTF-8-decode the version if needed in your programming language
         - This is the version
         */
        if let versionDelimiterIndex = string.lastIndex(of: "@") {
            let (remainder, version) = string.split(at: versionDelimiterIndex)
            self.version = version.removingPercentEncoding

            string = remainder
        } else {
            self.version = nil
        }

        /*
         Split the remainder once from right on '/'
         - The left side is the remainder
         - Percent-decode the right side. This is the name
         - UTF-8-decode this name if needed in your programming language
         - Apply type-specific normalization to the name if needed
         - This is the name
         */
        if let nameDelimiterIndex = string.lastIndex(of: "/") {
            let (remainder, name) = string.split(at: nameDelimiterIndex)
            guard let percentDecodedName = name.removingPercentEncoding?.nonempty else { return nil }
            self.name = percentDecodedName

            /*
             Split the remainder on '/'
             - Discard any empty segment from that split
             - Percent-decode each segment
             - UTF-8-decode the each segment if needed in your programming language
             - Apply type-specific normalization to each segment if needed
             - Join segments back with a '/'
             - This is the namespace
             */
            let namespace = remainder.split(separator: "/", omittingEmptySubsequences: true)
                                     .compactMap { segment in segment.removingPercentEncoding }
                                     .joined(separator: "/")
                                     .nonempty
            self.namespace = namespace
        } else {
            guard let name = string.removingPercentEncoding?.nonempty else { return nil }

            self.name = name
            self.namespace = nil
        }
    }

    /**
     Returns a string representation of the package URL.

     - Remark: Package URL representations are created according to the instructions provided at
               [PURL-SPECIFICATION.rst](https://github.com/package-url/purl-spec/blob/0b1559f76b79829e789c4f20e6d832c7314762c5/PURL-SPECIFICATION.rst#how-to-build-purl-string-from-its-components).
     */
    public var description: String {
        /* Start a purl string with the "pkg:" scheme as a lowercase ASCII string */
        var description: String = "pkg:"

        /*
         Append the type string to the purl as a lowercase ASCII string
         Append '/' to the purl
         */
        description.append(type)
        description.append("/")

        /*
         If the namespace is not empty:
         - Strip the namespace from leading and trailing '/'
         - Split on '/' as segments
         - Apply type-specific normalization to each segment if needed
         - UTF-8-encode each segment if needed in your programming language
         - Percent-encode each segment
         - Join the segments with '/'
         - Append this to the purl
         - Append '/' to the purl
         - Strip the name from leading and trailing '/'
         - Apply type-specific normalization to the name if needed
         - UTF-8-encode the name if needed in your programming language
         - Append the percent-encoded name to the purl
         */
        if let namespace = namespace?.addingPercentEncoding(withAllowedCharacters: purlAllowed) {
            description.append(namespace.split(separator: "/", omittingEmptySubsequences: true).joined(separator: "/"))
            description.append("/")
            description.append(name.trimmingCharacters(in: CharacterSet(charactersIn: "/")).addingPercentEncoding(withAllowedCharacters: purlAllowed) ?? "")
        } else {
            /*
             If the namespace is empty:
             * Apply type-specific normalization to the name if needed
             * UTF-8-encode the name if needed in your programming language
             * Append the percent-encoded name to the purl
            */
            description.append(name.addingPercentEncoding(withAllowedCharacters: purlAllowed) ?? "")
        }

        /*
         If the version is not empty:
         - Append '@' to the purl
         - UTF-8-encode the version if needed in your programming language
         - Append the percent-encoded version to the purl
         */
        if let version = version?.addingPercentEncoding(withAllowedCharacters: purlAllowed) {
            description.append("@")
            description.append(version)
        }

        /*
         If the qualifiers are not empty and not composed only of key/value pairs where the value is empty:
         - Append '?' to the purl
         - Build a list from all key/value pair:
         - discard any pair where the value is empty.
         - UTF-8-encode each value if needed in your programming language
         - If the key is checksums and this is a list of checksums join this list with a ',' to create this qualifier value
         - create a string by joining the lowercased key, the equal '=' sign and the percent-encoded value to create a qualifier
         - sort this list of qualifier strings lexicographically
         - join this list of qualifier strings with a '&' ampersand
         - Append this string to the purl
         */
        if let qualifiers = qualifiers?.filter({ !$0.value.isEmpty }), !qualifiers.isEmpty {
            description.append("?")
            description.append(qualifiers.sorted(by: { $0.key.lexicographicallyPrecedes($1.key) })
                                         .compactMap {
                                            guard let value = $0.value.addingPercentEncoding(withAllowedCharacters: purlAllowed) else { return nil }
                                            return "\($0.key)=\(value)"
                                         }.joined(separator: "&"))
        }

        /*
         If the subpath is not empty and not composed only of empty, '.' and '..' segments:
         - Append '#' to the purl
         - Strip the subpath from leading and trailing '/'
         - Split this on '/' as segments
         - Discard empty, '.' and '..' segments
         - Percent-encode each segment
         - UTF-8-encode each segment if needed in your programming language
         - Join the segments with '/'
         - Append this to the purl
         */
        if let subpathSegments = subpath?.split(separator: "/", omittingEmptySubsequences: true)
                                         .filter({ segment in segment.isValidSubpathSegment })
                                         .compactMap({ segment in segment.addingPercentEncoding(withAllowedCharacters: purlAllowed) }),
           !subpathSegments.isEmpty
        {
            description.append("#")
            description.append(subpathSegments.joined(separator: "/"))
        }

        return description
    }

    /**
     Returns a canonicalized version of the package URL,
     according to type-specific standards.

     For example,
     packages on PyPI are case-insensitive,
     and normalized by lowercasing and replacing underscores (`_`) with dashes (`-`).
     */
    public var canonicalized: PackageURL {
        var name = self.name
        switch (type) {
        case "bitbucket",
             "deb",
             "github",
             "golang",
             "hex",
             "npm":
            name = name.lowercased()
        case "pypi":
            name = name.lowercased().replacingOccurrences(of: "_", with: "-")
        default:
            break
        }

        var namespace = self.namespace
        switch (type) {
        case "bitbucket",
             "deb",
             "github",
             "hex",
             "rpm":
            namespace = namespace?.lowercased()
        default:
            break
        }

        return PackageURL(type: type,
                          namespace: namespace,
                          name: name,
                          version: version,
                          qualifiers: qualifiers,
                          subpath: subpath)
    }
}

// MARK: - Comparable

extension PackageURL: Comparable {
    public static func < (lhs: PackageURL, rhs: PackageURL) -> Bool {
        lhs.description < rhs.description
    }
}

// MARK: - Codable

extension PackageURL: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let purl = PackageURL(string) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "invalid package url")
        }

        self.init(purl)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

// MARK: -

extension PackageURL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        let purl = PackageURL(value)!
        self.init(purl)
    }
}

// MARK: -

fileprivate let purlAllowed = CharacterSet.alphanumerics
                                        .union(.punctuationCharacters)
                                        .subtracting(CharacterSet(charactersIn: "#?@"))

fileprivate extension StringProtocol {
    var isValidSubpathSegment: Bool {
        return !self.isEmpty && self != "." && self != ".."
    }

    func split(at index: Index) -> (prefix: SubSequence, suffix: SubSequence) {
        return (prefix(upTo: index), suffix(from: self.index(after: index)))
    }

    var nonempty: String? {
        guard !isEmpty else { return nil }
        return String(self)
    }
}
