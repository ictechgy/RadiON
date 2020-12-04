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
    @IBOutlet weak var levelFrom: UILabel!
    @IBOutlet weak var levelType: UILabel!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNationalStationsInfo), name: Notification.Name(fetchedNationalStationsInfo), object: nil) //이곳에 object 타입을 명시해주는 경우 제대로 호출이 안됨.. 왜지?
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
        var nearestStation: Station?
        var minDist: Double = .infinity //최대값
        for station in stations {
            if station.locationLatitude == nil || station.locationLongitude == nil { continue } //측정소 좌표가 정해지지 않았다면 스킵
            let dist = calcDist(userLoc: userLocation, stationInfo: station)
            if dist < minDist {
                minDist = dist
                nearestStation = station
            }
        }
        
        //Custom 뷰와 levelLabel에 보여줄 차례 + 어느 관측소 값인지 추가정보 표기
        var level: String
        var from: String
        var value: Double
        switch nearestStation {
        case .none:
            level = "N/A"
            from = "N/A"
            value = 0.0
        case .some(let station):
            level = String(station.doseEquivalent) + " µSv/h"
            from = "측정소 - [" + station.networkDelimitation.rawValue + "] " + station.locationName
            value =  station.doseEquivalent
        }
        
        
        levelFrom.text = from
        let levelWithColorAndValue: (Station.levelType, UIColor, Double) = Station.classifyLevel(value: value)
        
        levelLabel.text = level
        levelType.text = " (" + levelWithColorAndValue.0.rawValue + " )"
        levelType.textColor = levelWithColorAndValue.1
        circularView.progressLayerStrokeColor = levelWithColorAndValue.1.cgColor
        circularView.setValueAndProgressAnimation(estimated: levelWithColorAndValue.2)
    }
    
    func calcDist(userLoc: CLLocationCoordinate2D, stationInfo: Station) -> Double {
        //단순히 위경도 차이 값을 구하는 것이긴 한데 편서풍을 고려해야 할까? 남서쪽 관측소에 가중치를 둔다던지..
        //그리고 위도 값 차이 자체는 거리에 대한 차이로도 쓸 수 있지만(지구가 완전히 둥글다고 가정했을 때)
        //경도 값 자체는 위도에 따라 실질적인 거리가 달라지는데 이를 그대로 써도 되는걸까?
        
        return pow(userLoc.latitude - stationInfo.locationLatitude!, 2) + pow(userLoc.longitude - stationInfo.locationLongitude!, 2)
        //sqrt()를 씌우지 않은 이유는 어차피 큰 의미가 없기 때문. 제곱 값으로 비교하나 제곱근으로 비교하나..
    }
    
}

