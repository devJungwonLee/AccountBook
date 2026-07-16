//
//  BankAssetRepository.swift
//  AccountBook
//
//  Created by 이정원 on 2026/07/14.
//

import Foundation
import ZIPFoundation

enum BankAssetRepositoryError: Error {
    case notImplemented
    case checksumMismatch
    case invalidAssets
}

struct BankAssetRepository: BankAssetRepositoryType {
    private let networkService: NetworkService
    private let fileManager: FileManager
    
    init(networkService: NetworkService = .init()) {
        self.networkService = networkService
        self.fileManager = FileManager.default
    }
    
    func synchronize() async throws {
        let manifest = try await fetchManifest()
        let localManifest = try fetchLocalManifest()
        let shouldDownload = manifest.sha256 != localManifest?.sha256
        guard shouldDownload else { return }
        try await saveAssets(manifest)
    }

    func fetchBankList() throws -> [Bank] {
        let data = try Data(contentsOf: bankListURL)
        return try JSONDecoder().decode([Bank].self, from: data)
    }

    func logoURL(for bankCode: String) -> URL? {
        return nil
    }
}

private extension BankAssetRepository {
    func fetchManifest() async throws -> BankAssetManifest {
        let endpoint = BankAssetEndpoint.manifest
        return try await networkService.request(endpoint)
    }
    
    func fetchLocalManifest() throws -> BankAssetManifest? {
        let manifestURL = try manifestURL
        let fileExists = fileManager.fileExists(atPath: manifestURL.path)
        guard fileExists else { return nil }
        let data = try Data(contentsOf: manifestURL)
        return try JSONDecoder().decode(BankAssetManifest.self, from: data)
    }
    
    func saveAssets(_ manifest: BankAssetManifest) async throws {
        let endpoint = BankAssetEndpoint.assets
        let url = try await networkService.download(endpoint)
        try unzip(url, manifest)
    }

    func unzip(_ url: URL, _ manifest: BankAssetManifest) throws {
        let data = try Data(contentsOf: url)
        guard data.sha256 == manifest.sha256 else { return }

        try? fileManager.removeItem(at: tempURL)
        try fileManager.unzipItem(at: url, to: tempURL)

        let manifestData = try JSONEncoder().encode(manifest)
        let tempManifestURL = try tempURL.appendingPathComponent("manifest.json")
        try manifestData.write(to: tempManifestURL, options: .atomic)

        let bankAssetsURL = try bankAssetsURL

        if fileManager.fileExists(atPath: bankAssetsURL.path) {
            _ = try fileManager.replaceItemAt(bankAssetsURL, withItemAt: tempURL)
        } else {
            try fileManager.moveItem(at: tempURL, to: bankAssetsURL)
        }
    }
}

private extension BankAssetRepository {
    var bankAssetsURL: URL {
        get throws {
            try fileManager.assetStorageURL
                .appendingPathComponent("bank_assets")
        }
    }
    
    var manifestURL: URL {
        get throws {
            try bankAssetsURL
                .appendingPathComponent("manifest.json")
        }
    }

    var tempURL: URL {
        get throws {
            try fileManager.assetStorageURL
                .appendingPathComponent("temp")
        }
    }
    
    var bankListURL: URL {
        get throws {
            try bankAssetsURL
                .appendingPathComponent("bank_list.json")
        }
    }
}
