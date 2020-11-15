//
//  Location.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/14.
//

import Foundation
import CoreLocation

let centerOfSeoul: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.33, longitude: 26.59)

//user location 정보를 저장하고 있는 싱글톤 객체
class Location{
    static let shared = Location()
    private init(){}
    //swift의 singletone은 java의 lazyholder급이라고 한다.
    
    private var _latitude: CLLocationDegrees = centerOfSeoul.latitude
    private var _longitude: CLLocationDegrees = centerOfSeoul.longitude
    //default value 설정
     
    var latitude: CLLocationDegrees {
        get {
            return _latitude
        }
        set {
            _latitude = newValue
        }
    }
    
    var longitude: CLLocationDegrees {
        get {
            return _longitude
        }
        set {
            _longitude = newValue
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self._latitude, longitude: self._longitude)
        }
        set {
            self._latitude = newValue.latitude
            self._longitude = newValue.longitude
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
