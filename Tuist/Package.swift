// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [:],
        baseSettings: .settings()
    )
#endif

let package = Package(
    name: "AccountBook",
    dependencies: [
        .package(url: "https://github.com/devxoul/Then.git", exact: "3.0.0"),
        .package(url: "https://github.com/DevYeom/ModernRIBs.git", exact: "1.0.2"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.6.0"),
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", exact: "1.8.1"),
    ]
)
