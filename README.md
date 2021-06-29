# PackageURL

Swift implementation of the [package url specification][purl-spec].

## Requirements

- Swift 5.3+

## Usage

```swift
import PackageURL

let purl: PackageURL = "pkg:swift/apple/swift-argument-parser@0.4.3"
purl.type // "swift"
purl.namespace // "apple"
purl.name // "swift-argument-parser"
purl.version // "0.4.3"

purl.description // "pkg:swift/apple/swift-argument-parser@0.4.3"
```

## Installation

To use the `PackageURL` library in a Swift project,
add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/mattt/packageurl-swift", from: "0.0.1"),
```

Finally, include `"PackageURL"` as a dependency for your executable target:

```swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        .package(url: "https://github.com/mattt/packageurl-swift", from: "0.0.1"),
        // other dependencies
    ],
    targets: [
        .target(name: "<#target#>", dependencies: [
            .product(name: "PackageURL", package: "packageurl-swift"),
        ]),
        // other targets
    ]
)
```

## License

MIT

[purl-spec]: https://github.com/package-url/purl-spec
