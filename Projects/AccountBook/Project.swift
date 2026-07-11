import ProjectDescription

let appName = "AccountBook"
let deploymentTarget = "15.0"
let developmentTeam = "VBT5J7U68Y"

let baseTargetSettings: SettingsDictionary = [
    "CODE_SIGN_STYLE": "Automatic",
    "CURRENT_PROJECT_VERSION": "1",
    "DEVELOPMENT_TEAM": .string(developmentTeam),
    "MARKETING_VERSION": "1.0",
    "SWIFT_EMIT_LOC_STRINGS": "YES",
    "SWIFT_VERSION": "5.0",
]

let extensionRunpaths: SettingsDictionary = [
    "LD_RUNPATH_SEARCH_PATHS": [
        "$(inherited)",
        "@executable_path/Frameworks",
        "@executable_path/../../Frameworks",
    ],
    "SKIP_INSTALL": "YES",
]

let project = Project(
    name: appName,
    organizationName: "jungwon",
    options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    settings: .settings(
        base: [
            "CLANG_CXX_LANGUAGE_STANDARD": "gnu++20",
            "DEVELOPMENT_TEAM": .string(developmentTeam),
            "IPHONEOS_DEPLOYMENT_TARGET": .string(deploymentTarget),
            "SWIFT_VERSION": "5.0",
        ],
        configurations: [
            .debug(name: "Debug", settings: [
                "GCC_PREPROCESSOR_DEFINITIONS": [
                    "DEBUG=1",
                    "$(inherited)",
                ],
                "INFOPLIST_KEY_CFBundleDisplayName": "계좌번호부",
                "MTL_ENABLE_DEBUG_INFO": "INCLUDE_SOURCE",
                "ONLY_ACTIVE_ARCH": "YES",
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            ], xcconfig: "Config/Secrets.xcconfig"),
            .release(name: "Release", settings: [
                "INFOPLIST_KEY_CFBundleDisplayName": "계좌번호부",
                "MTL_ENABLE_DEBUG_INFO": "NO",
                "SWIFT_COMPILATION_MODE": "wholemodule",
                "SWIFT_OPTIMIZATION_LEVEL": "-O",
                "VALIDATE_PRODUCT": "YES",
            ], xcconfig: "Config/Secrets.xcconfig"),
        ]
    ),
    targets: [
        .target(
            name: appName,
            destinations: .iOS,
            product: .app,
            bundleId: "com.jungwon.AccountBook",
            deploymentTargets: .iOS(deploymentTarget),
            infoPlist: .file(path: "Support/Info.plist"),
            sources: [
                "Sources/**/*.swift",
                "Support/AccountBookIntents.intentdefinition",
            ],
            resources: [
                "Resources/**",
            ],
            entitlements: .file(path: "Support/AccountBook.entitlements"),
            dependencies: [
                .target(name: "AccountBookWidgetExtension"),
                .target(name: "IntentsExtension"),
                .external(name: "Then"),
                .external(name: "ModernRIBs"),
                .external(name: "SnapKit"),
                .external(name: "CombineExt"),
                .sdk(name: "WidgetKit", type: .framework),
            ],
            settings: .settings(base: baseTargetSettings.merging([
                "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES": "YES",
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                "INFOPLIST_KEY_NSFaceIDUsageDescription": "생체인증을 통해 보안이 필요한 동작을 수행할 수 있습니다.",
                "INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents": "YES",
                "INFOPLIST_KEY_UIMainStoryboardFile": "",
                "INFOPLIST_KEY_UISupportedInterfaceOrientations": "UIInterfaceOrientationPortrait",
                "INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad": "UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown",
                "LD_RUNPATH_SEARCH_PATHS": [
                    "$(inherited)",
                    "@executable_path/Frameworks",
                ],
                "SUPPORTED_PLATFORMS": "iphoneos iphonesimulator",
                "SUPPORTS_MACCATALYST": "NO",
                "SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD": "NO",
                "TARGETED_DEVICE_FAMILY": "1",
            ])),
            coreDataModels: [
                .coreDataModel("Model.xcdatamodeld"),
            ]
        ),
        .target(
            name: "AccountBookWidgetExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.jungwon.AccountBook.AccountBookWidget",
            deploymentTargets: .iOS(deploymentTarget),
            infoPlist: .file(path: .relativeToRoot("Projects/AccountBookWidget/Support/Info.plist")),
            sources: [
                "Sources/Constants/ContainerIdentifier.swift",
                "Sources/Constants/GroupIdentifier.swift",
                "Sources/Data/PersistentData/*.swift",
                "Sources/Data/PersistentStorage/PersistentStorage.swift",
                "Sources/Domain/Entities/Account.swift",
                "Sources/Domain/Entities/Bank.swift",
                "Support/AccountBookIntents.intentdefinition",
                .glob(.relativeToRoot("Projects/AccountBookWidget/Sources/**/*.swift")),
                .glob(.relativeToRoot("Projects/IntentsExtension/Sources/IntentHandler.swift")),
            ],
            resources: [
                "Resources/Assets.xcassets",
            ],
            entitlements: .file(path: .relativeToRoot("Projects/AccountBookWidget/Support/AccountBookWidgetExtension.entitlements")),
            dependencies: [
                .sdk(name: "Intents", type: .framework),
                .sdk(name: "WidgetKit", type: .framework),
            ],
            settings: .settings(base: baseTargetSettings.merging(extensionRunpaths).merging([
                "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                "INFOPLIST_KEY_CFBundleDisplayName": "AccountBookWidget",
                "INFOPLIST_KEY_NSHumanReadableCopyright": "",
                "TARGETED_DEVICE_FAMILY": "1",
            ])),
            coreDataModels: [
                .coreDataModel("Model.xcdatamodeld"),
            ]
        ),
        .target(
            name: "IntentsExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.jungwon.AccountBook.IntentsExtension",
            deploymentTargets: .iOS(deploymentTarget),
            infoPlist: .file(path: .relativeToRoot("Projects/IntentsExtension/Support/Info.plist")),
            sources: [
                "Sources/Constants/ContainerIdentifier.swift",
                "Sources/Constants/GroupIdentifier.swift",
                "Sources/Data/PersistentData/*.swift",
                "Sources/Data/PersistentStorage/PersistentStorage.swift",
                "Sources/Domain/Entities/Account.swift",
                "Sources/Domain/Entities/Bank.swift",
                "Support/AccountBookIntents.intentdefinition",
                .glob(.relativeToRoot("Projects/IntentsExtension/Sources/IntentHandler.swift")),
            ],
            resources: [
                "Resources/Assets.xcassets",
            ],
            entitlements: .file(path: .relativeToRoot("Projects/IntentsExtension/Support/IntentsExtension.entitlements")),
            dependencies: [
                .sdk(name: "Intents", type: .framework),
            ],
            settings: .settings(base: baseTargetSettings.merging(extensionRunpaths).merging([
                "INFOPLIST_KEY_CFBundleDisplayName": "IntentsExtension",
                "INFOPLIST_KEY_NSHumanReadableCopyright": "",
                "TARGETED_DEVICE_FAMILY": "1,2",
            ])),
            coreDataModels: [
                .coreDataModel("Model.xcdatamodeld"),
            ]
        ),
    ],
    resourceSynthesizers: []
)
