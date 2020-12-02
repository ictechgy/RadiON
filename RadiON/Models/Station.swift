//
//  Station.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/23.
//

import Foundation

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
        case underInspection = "점검"
        case unknownLevel = "알 수 없음"
    }
    
    /// 값에 따라 준위를 구분. 주의가 필요하다. 국가환경방사선자동감시망의 경보설정에 대한 기준은 최근 3년치 평균 값을 이용하고 있으나 해당 3년치 평균 값을 지역별로, 또 자동적으로 구할 수가 없다. 따라서 일반적 자연변동 범위인 0.05~0.30µSv/h를 정상으로 표기하고 0.973µSv/h 미만을 주의, 그 이상은 경고로 한다. 973µSv/h 이상은 비상으로 한다. 이는 사용자 화면에도 보여져야 한다. (앱 최초시작 팝업에서 한번, 메인화면 하단에서 상시)
    static func classifyLevel(value: Double?) -> levelType {
        var type: levelType
        switch value {
        case .none:
            type = .underInspection
        case .some(let value):
            switch value {
            case 0.05...0.30:
                type = .normal
            case 0.30..<0.973:
                type = .caution
            case 0.973..<973:
                type = .warning
            case 973...:
                type = .emergency
            default:
                type = .unknownLevel
            }
        }
        return type
    }
    //메소드 위치를 고민했었는데 NetworkHandler에서 Station으로 바꿈. 준위와 관련되어있으며 levelType enum을 쓸 것이므로.
    
    //이부분 경고와 함께 작성해야하며..(나중에는 앱 시작화면 및 메인화면 하단에서 알려주는게 좋을 듯)
    //이전 커밋에서 관측소 값들을 사용자의 위치가 얻어진 이후에 받아지도록 했는데 사실 다시 바꿔야함.
    //지도화면에서는 위치권한이 있든 없든 관측소 데이터는 받아야 하기 때문
    //따라서 Notification을 다르게 설정해야 할 필요성이 있음. 아니면 어떤 Delegate를 만들어 구현하던가.. (이 때에는 Retain Cycle 주의)
    
}
