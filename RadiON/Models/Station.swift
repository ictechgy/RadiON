//
//  Station.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/23.
//

import Foundation

//관측소
struct Station {
    var networkDelimitation: networkType?
    var locationName: String?
    var locationLatitude: Double?
    var locationLongitude: Double?
    
    var doseEquivalent: Double?
    var exposure: Double?
    
    var status: levelType?
    
    enum networkType {
        case national
        case business
        case localGovernment
    }
    
    enum levelType: String {    //준위
        case normal = "정상"
        case caution = "주의"
        case warning = "경고"
        case emergency = "비상"
    }
    
}
