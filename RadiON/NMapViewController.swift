//
//  NMapViewController.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/17.
//

import UIKit
import CoreLocation
import NMapsMap

class NMapViewController: UIViewController, NMFAuthManagerDelegate {
    
    let errorTitle: String = "에러 발생"
    let errorMsg: String = "지도 정보를 가져오던 도중 문제가 발생했습니다. 나중에 다시 시도하십시오."
    
    @IBOutlet weak var mapContainerView: UIView!
    var naverMapView: NMFNaverMapView!
    var mapView: NMFMapView!
    
    var mainTabBarController: MainTabBarController?

    override func viewDidLoad() {
        super.viewDidLoad()
        NMFAuthManager.shared().delegate = self

        // Do any additional setup after loading the view.
        naverMapView = NMFNaverMapView(frame: mapContainerView.frame)
        mapContainerView.addSubview(naverMapView)

        mapView = naverMapView.mapView
        
        naverMapView.showCompass = true
        naverMapView.showZoomControls = true
        naverMapView.showIndoorLevelPicker = false
        naverMapView.showLocationButton = true
        
        mapView.buildingHeight = 0
        mapView.isTiltGestureEnabled = false
        mapView.minZoomLevel = 6   //대한민국이 한 화면에 딱 맞게 들어올 정도의 줌레벨
        
        //viewDidLoad 시 최초 지도 화면은 대한민국 전체에 걸쳐 보이도록 만들기
        let centerOfKorea: NMGLatLng = NMGLatLng(lat: (farNorth + farSouth) / 2, lng: (farWest + farEast) / 2 - 0.5)    //'0.5'는 동-서 위치 보정 값
        let cameraPosition = NMFCameraPosition(centerOfKorea, zoom: 6)
        naverMapView.mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))
        
        guard let tabBarController: MainTabBarController = tabBarController as? MainTabBarController else {
            return
        }
        mainTabBarController = tabBarController
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLocationAuthStatus), name: Notification.Name(rawValue: locationAuthStatus), object: CLAuthorizationStatus.self)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLocationInfo), name: Notification.Name(ReceivedLocationInfo), object: nil)
        
        mainTabBarController?.requestLocationPermission()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didReceiveLocationAuthStatus(noti: CLAuthorizationStatus) {
        switch noti {
        case .denied, .notDetermined, .restricted:
            naverMapView.positionMode = .disabled
        default:
            naverMapView.positionMode = .normal
        }
    }
    
    @objc func didReceiveLocationInfo() {
        if Location.shared.state == .loaded {
            let locationOverlay = naverMapView.mapView.locationOverlay
            locationOverlay.location = NMGLatLng(from: Location.shared.coordinate)
        }
    }
    
    func authorized(_ state: NMFAuthState, error: Error?) {
        if state == .unauthorized {
            
            let alert: UIAlertController = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
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
