import Foundation

protocol BankAssetRepositoryType {
    func synchronize() async throws
    func fetchBankList() async throws -> [Bank]
    func logoURL(for bankCode: String) -> URL?
}
