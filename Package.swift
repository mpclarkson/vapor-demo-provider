import PackageDescription

let package = Package(
    name: "VaporDemoProvider",
    dependencies: [
   		.Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1),
    ]
)
