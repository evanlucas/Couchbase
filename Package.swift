// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Couchbase",
    products: [
      .library(name: "Couchbase",
               targets: ["Couchbase"]),
    ],
    dependencies: [
      .package(url: "https://github.com/evanlucas/Libcouchbase",
               from: "1.0.0")
    ],
    targets: [
      .target(name: "Couchbase",
              dependencies: []),
      .testTarget(name: "CouchbaseTests",
                  dependencies: ["Couchbase"]),
    ]
)
