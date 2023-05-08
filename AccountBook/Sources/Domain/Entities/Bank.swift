//
//  Bank.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/08.
//

enum Bank: CaseIterable {
    static var allCases: [Bank] {
        return [
            .kb, .ibk, .nh, .kdb, .shinhan, .woori,
            .sc, .hana, .citi, .kakaobank, .kbank, .tossbank,
            .knbank, .kjbank, .dgb, .bsbank, .jbbank, .jjbank,
            .savingsbank, .sj, .mg, .sh, .cu, .post
        ]
    }
    
    case kb
    case ibk
    case nh
    case kdb
    case shinhan
    case woori
    case sc
    case hana
    case citi
    case kakaobank
    case kbank
    case tossbank
    case knbank
    case kjbank
    case dgb
    case bsbank
    case jbbank
    case jjbank
    case savingsbank
    case sj
    case mg
    case sh
    case cu
    case post
    case etc(String)
    
    var code: String {
        switch self {
        case .kb: return "kb"
        case .ibk: return "ibk"
        case .nh: return "nh"
        case .kdb: return "kdb"
        case .shinhan: return "shinhan"
        case .woori: return "woori"
        case .sc: return "sc"
        case .hana: return "hana"
        case .citi: return "citi"
        case .kakaobank: return "kakaobank"
        case .kbank: return "kbank"
        case .tossbank: return "tossbank"
        case .knbank: return "knbank"
        case .kjbank: return "kjbank"
        case .dgb: return "dgb"
        case .bsbank: return "bsbank"
        case .jbbank: return "jbbank"
        case .jjbank: return "jjbank"
        case .savingsbank: return "savingsbank"
        case .sj: return "sj"
        case .mg: return "mg"
        case .sh: return "sh"
        case .cu: return "cu"
        case .post: return "post"
        case .etc: return "etc"
        }
    }
    
    var name: String {
        switch self {
        case .kb: return "KB국민은행"
        case .ibk: return "IBK기업은행"
        case .nh: return "NH농협은행"
        case .kdb: return "KDB산업은행"
        case .shinhan: return "신한은행"
        case .woori: return "우리은행"
        case .sc: return "SC제일은행"
        case .hana: return "하나은행"
        case .citi: return "한국씨티은행"
        case .kakaobank: return "카카오뱅크"
        case .kbank: return "케이뱅크"
        case .tossbank: return "토스뱅크"
        case .knbank: return "케이뱅크"
        case .kjbank: return "광주은행"
        case .dgb: return "대구은행"
        case .bsbank: return "부산은행"
        case .jbbank: return "전북은행"
        case .jjbank: return "제주은행"
        case .savingsbank: return "저축은행"
        case .sj: return "산림조합"
        case .mg: return "새마을금고"
        case .sh: return "수협"
        case .cu: return "신협"
        case .post: return "우체국"
        case .etc: return "기타"
        }
    }
}
