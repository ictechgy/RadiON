//
//  MainTabBarController.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/12.
//

import UIKit
import CoreLocation

class MainTabBarController: UITabBarController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager! //LocationManager객체는 TabBarContainer에서 관리하자 -> 홈화면과 지도화면에서 동시 사용하므로.

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestLocationPermission()
    }
    
    func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied, .restricted:
            showAlert()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            showAlert()
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //locationManager instance 생성 및 Auth 상태 변경시 호출
        requestLocationPermission()
    }
    
    func showAlert() {
        let alert: UIAlertController = UIAlertController(title: "'라디온'이 사용자의 위치를 사용하도록 허용해주세요 ", message: "가장 가까운 측정소 정보를 쉽게 확인하기 위해서는 위치정보 접근 권한이 필요합니다.", preferredStyle: .alert)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //location value 못얻을 시
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
