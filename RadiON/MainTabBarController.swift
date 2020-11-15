//
//  MainTabBarController.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/12.
//

import UIKit
import CoreLocation

let locationAuthStatus: String = "LocationAuthStatus"

class MainTabBarController: UITabBarController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager! //LocationManager객체는 TabBarContainer에서 관리하자 -> 홈화면과 지도화면에서 동시 사용하므로.

    //MARK: - Life Cycle
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
    
    //MARK: - Custom Methods
    func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            Location.shared.state = .loading
        case .denied, .restricted:
            showAlert()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            showAlert()
        }
        
        //이제 여기서 Notification Center를 통해 status를 각 뷰컨트롤러로 전파
        let notiCenter: NotificationCenter = NotificationCenter.default
        notiCenter.post(name: NSNotification.Name(locationAuthStatus), object: locationManager.authorizationStatus)
        //넘기는 오브젝트 타입: CLAuthorizationStatus
    }
    
    func showAlert() {
        let alert: UIAlertController = UIAlertController(title: "'라디온'이(가) 사용자의 위치를 사용하도록 허용해주세요 ", message: "가장 가까운 측정소 정보를 쉽게 확인하기 위해서는 위치정보 접근 권한이 필요합니다. 확인을 누르시면 설정 창으로 이동합니다.", preferredStyle: .alert)
        
        let toSetting: UIAlertAction = UIAlertAction(title: "설정", style: .default) { _ in
            //Radion Setting창으로 이동
        }
        
        let cancel: UIAlertAction = UIAlertAction(title: "허용 안 함", style: .cancel, handler: nil)
        
        alert.addAction(toSetting)
        alert.addAction(cancel)
    }
    
    
    //MARK:- Location Manager Delegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //locationManager instance 생성 및 Auth 상태 변경시 호출
        requestLocationPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //request location 성공 시 호출
        Location.shared.coordinate = locations[locations.endIndex-1].coordinate
        Location.shared.state = .loaded
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //location value 못얻을 시
        Location.shared.state = .error
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
