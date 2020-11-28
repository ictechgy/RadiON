//
//  Location.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/14.
//

import Foundation
import CoreLocation

/// 서울의 중심점 좌표입니다. 서울특별시 용산구 좌표로 설정되어있습니다.
let centerOfSeoul: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.528582, longitude: 126.981987)  //용산 좌표
/// 대한민국 최북단
let farNorth: Double = 38.45
/// 대한민국 최남단
let farSouth: Double = 33.1
/// 대한민국 최동단
let farEast: Double = 131.872
/// 대한민국 최서단
let farWest: Double = 125.06
//대한민국의 각 끝점 좌표

/// user location 정보를 저장하고 있는 싱글톤 객체
class Location{
    static let shared = Location()
    private init(){}
    //swift의 singletone은 java의 lazyholder급이라고 한다.
    
    private var _latitude: CLLocationDegrees = centerOfSeoul.latitude
    private var _longitude: CLLocationDegrees = centerOfSeoul.longitude
    //default value 설정
    
    /// 행정구역 - 시
    var administrativeArea: String? //시
    /// 행정구역 - 구
    var locality: String?   //구
    /// 행정구역 - 동
    var thoroughfare: String?   //동
    /// 사용자의 위치 반환 ex) 00시 00구
    var userAddress: String?{
        if let administrativeArea = administrativeArea, let locality = locality{
            return administrativeArea + " " + locality
        }
        return nil
    }
     
    /// 사용자 위치의 위도 값, 초기 값은 용산구로 설정되어 있습니다. 대한민국 범위 내로만 설정 가능합니다.
    var latitude: CLLocationDegrees {
        get {
            return _latitude
        }
        set {
            if newValue >= farSouth && newValue <= farNorth {
                _latitude = newValue
            }
        }
    }
    
    /// 사용지 위치의 경도 값, 초기 값은 용산구로 설정되어 있습니다. 대한민국 범위 내로만 설정 가능합니다.
    var longitude: CLLocationDegrees {
        get {
            return _longitude
        }
        set {
            if newValue >= farWest && newValue <= farEast {
                _longitude = newValue
            }
        }
    }
    
    /// 사용자 좌표 객체
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self._latitude, longitude: self._longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    /// 사용자 위치에 대한 정보 습득 상태를 나타냅니다.
    private var _state: condition = condition.initialized
    var state: condition {
        get {
            return _state
        }
        set {
            self._state = newValue
        }
    }
    
    enum condition {
        case initialized
        case loading
        case loaded
        case error
    }
    
}
