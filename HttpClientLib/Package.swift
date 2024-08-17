// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HttpClientLib",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HttpClientLib",
            targets: ["HttpClientLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.9.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HttpClientLib",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ]),
        .testTarget(
            name: "HttpClientLibTests",
            dependencies: ["HttpClientLib"]),
    ]
)
