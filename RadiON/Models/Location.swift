//
//  Location.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/14.
//

import Foundation
import CoreLocation

let centerOfSeoul: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.528582, longitude: 126.981987)  //용산 좌표
let farNorth: Double = 38.45
let farSouth: Double = 33.1
let farEast: Double = 131.872
let farWest: Double = 125.06
//대한민국의 각 끝점 좌표

//user location 정보를 저장하고 있는 싱글톤 객체
class Location{
    static let shared = Location()
    private init(){}
    //swift의 singletone은 java의 lazyholder급이라고 한다.
    
    private var _latitude: CLLocationDegrees = centerOfSeoul.latitude
    private var _longitude: CLLocationDegrees = centerOfSeoul.longitude
    //default value 설정
    
    var administrativeArea: String? //시
    var locality: String?   //구
    var thoroughfare: String?   //동
    var userAddress: String?{
        if let administrativeArea = administrativeArea, let locality = locality{
            return administrativeArea + " " + locality
        }
        return nil
    }
     
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
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self._latitude, longitude: self._longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
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
