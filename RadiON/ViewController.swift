//
//  ViewController.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/11.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    @IBOutlet weak var circularView: HalfCircularProgressView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    
    let locError: String = "?"
    let locLoading: String = "loading"
    let locNotAuthorizedMsg: String = "위치정보를 불러올 수 없음"

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLocationAuthStatus), name: Notification.Name(rawValue: locationAuthStatus), object: CLAuthorizationStatus.self)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLocationInfo), name: Notification.Name(ReceivedLocationInfo), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNationalStationsInfo), name: Notification.Name(fetchedNationalStationsInfo), object: [Station].self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Custom Methods
    @objc func didReceiveLocationAuthStatus(noti: Notification) {
        //Auth 상태에 따라 ProgressBar Animation activated
        
        guard let status: CLAuthorizationStatus = noti.object as? CLAuthorizationStatus else {
            levelLabel.text = locError
            levelLabel.setNeedsDisplay()
            userAddress.text = locNotAuthorizedMsg
            return
        }
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            levelLabel.text = locLoading
        default:    //거부되거나 아직 정해지지 않은 경우에는 ?만 띄웁니다.
            levelLabel.text = locError
            userAddress.text = locNotAuthorizedMsg
        }
        levelLabel.setNeedsDisplay()
    }
    
    @objc func didReceiveLocationInfo() {
        if Location.shared.state != .loaded {
            levelLabel.text = locError
            levelLabel.setNeedsDisplay()
            userAddress.text = locNotAuthorizedMsg
            return
        }
        userAddress.text?.append(Location.shared.userAddress ?? "알 수 없음")
    }
    
    @objc func didReceiveNationalStationsInfo(noti: Notification){
        
        //사용자의 위치를 알 수 없다면(가져오지 못했다면) 가까운 측정소 값을 보여주는 것은 무의미
        if Location.shared.state != .loaded {
            return
        }
        
        guard let stations: [Station] = noti.object as? [Station] else {
            return
        }
        
        //사용자 위치하고 가장 가까운 관측소를 찾아야 한다.
        //어떤 방식으로 찾는게 효율적일까?
        //사용자의 위치값하고만 비교하여 최소값을 찾으면 되므로 단순 선형검색을 해도 O(n) 나온다. (관측소의 수도 적음)
        
        let userLocation = Location.shared.coordinate
        var nearestStation: Station
        var minDist: Double
        for station in stations {
            let dist = calcDist(userLoc: userLocation, stationInfo: station)
            if minDist.is
        }
    }
    
    func calcDist(userLoc: CLLocationCoordinate2D, stationInfo: Station) -> Double {
        <#function body#>
    }
    
}

