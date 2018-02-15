// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftServer",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
    	.package(url: "https://github.com/IBM-Swift/BlueSocket", from: "0.12.83")
    ],
    targets: [
        .target(
            name:"Main",
            dependencies: ["Server", "Utility"]),
        .target(
            name: "Server",
            dependencies: ["Socket"]),
        .testTarget(
            name:"Test", 
            dependencies: ["Server"])
    ]
)
