// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HomoglyphInspector",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "HomoglyphInspector", targets: ["HomoglyphInspector"])
    ],
    targets: [
        .executableTarget(name: "HomoglyphInspector", path: "Sources")
    ]
)
