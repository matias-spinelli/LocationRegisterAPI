// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "LocationRegisterAPI",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        .package(url: "https://github.com/orlandos-nl/MongoKitten.git", from: "7.5.0")
    ],
    targets: [
        .executableTarget(
            name: "LocationRegisterAPI",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "MongoKitten", package: "MongoKitten")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "LocationRegisterAPITests",
            dependencies: [
                .target(name: "LocationRegisterAPI"),
                .product(name: "VaporTesting", package: "vapor"),
            ]
        )
    ]
)
