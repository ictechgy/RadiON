//
//  Station.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/23.
//

import Foundation
import UIKit.UIColor

/// 관측소
struct Station {
    /// 어떤 망에 속해있는지 나타내는 프로퍼티
    var networkDelimitation: networkType
    /// 행정구역
    var administrativeArea: String
    /// 구체적 지명
    var locationName: String
    /// 위도
    var locationLatitude: Double?
    /// 경도
    var locationLongitude: Double?
    
    /// 등가선량 - 표준단위는 시버트(Sievert, Sv)이며 이 프로퍼티에서는 'μSv/h'단위 사용
    var doseEquivalent: Double
    /// 조사선량 - 단위: 'μR/h'
    var exposure: Double
    
    /// 해당 관측소 준위를 나타냄
    var status: levelType
    
    enum networkType: String {
        case national = "국가망"
        case business = "사업자망"
        case localGovernment = "지자체망"
        case unknownNetwork = "알 수 없음"
    }
    
    enum levelType: String {    //준위
        case normal = "정상"
        case caution = "주의"
        case warning = "경고"
        case emergency = "비상"
        case underInspection = "점검 중"     //점검 중인 경우에 이름은 '점검 중'으로, 등가선량과 조사선량은 fetch시 csv파일에 - 기호로 들어옴
        case unknownLevel = "알 수 없음"
    }
    
}
