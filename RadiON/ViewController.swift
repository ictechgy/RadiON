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
    
}

