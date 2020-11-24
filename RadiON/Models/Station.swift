//
//  Station.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/23.
//

import Foundation

//관측소
struct Station {
    var networkDelimitation: networkType
    var administrativeArea: String
    var locationName: String
    var locationLatitude: Double?
    var locationLongitude: Double?
    
    var doseEquivalent: Double?
    var exposure: Double?
    
    var status: levelType?
    
    init(networkType: networkType, administrativeArea: String, locationName: String) {
        self.networkDelimitation = networkType
        self.administrativeArea = administrativeArea
        self.locationName = locationName
    }
    
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
    
}
