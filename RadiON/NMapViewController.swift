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
    
    var naverMapView: NMFNaverMapView!
    var mapView: NMFMapView!
    
    var mainTabBarController: MainTabBarController?

    override func viewDidLoad() {
        super.viewDidLoad()
        NMFAuthManager.shared().delegate = self

        // Do any additional setup after loading the view.
        naverMapView = NMFNaverMapView(frame: view.frame)
        view.addSubview(naverMapView)

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
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNationalStationsInfo), name: Notification.Name(fetchedNationalStationsInfo), object: nil)
        
        mainTabBarController?.requestLocationPermission()
        mainTabBarController?.requestData()
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
            locationOverlay.hidden = false  //설정 후 보여주기. (현재 내 위치 버튼 안눌러도 기본적으로 보이도록)
        }
    }
    
    @objc func didReceiveNationalStationsInfo(noti: Notification){
        
        guard let stations: [Station] = noti.object as? [Station] else {
            return
        }
        
        //가져온 측정소 정보 지도에 보여주기
        //마커를 만드는 작업은 백그라운드에서 수행하고 보여주는 부분만 메인쓰레드에서 수행
        DispatchQueue.global(qos: .default).async {
            var markers: [NMFMarker] = [] // = [NMFMarker](repeating: NMFMarker(), count: stations.count)
            for station in stations {
                let marker = NMFMarker(position: NMGLatLng(lat: station.locationLatitude!, lng: station.locationLongitude!))
                //위경도 값은 nil일 수 없음. AssetsLoader에서 merge할 때 값이 없는 경우 0.0으로 넣도록 만듬.
                
                //marker 세팅
                marker.iconTintColor = Station.classifyLevel(value: station.doseEquivalent).1
                marker.height = 25.0
                marker.width = 20.0
                marker.isHideCollidedSymbols = true
                markers.append(marker)
            }
            
            DispatchQueue.main.async { [weak self] in   //비동기적으로 시행되다보니 메인쓰레드에서 마커를 추가하려고 할 때 사용자가 화면을 바꿨을 수 있음. 따라서 self가 없을 수 있다.
                for marker in markers {
                    marker.mapView = self?.mapView
                }
            }
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
