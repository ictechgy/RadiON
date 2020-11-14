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
    
    let locError: String = "?"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLocationAuthStatus), name: NSNotification.Name(rawValue: locationAuthStatus), object: CLAuthorizationStatus.self)
    }
    
    @objc func didReceiveLocationAuthStatus(noti: Notification) {
        //Auth 상태에 따라 ProgressBar Animation activated
        
        guard let status: CLAuthorizationStatus = noti.object as? CLAuthorizationStatus else {
            levelLabel.text = locError
            return
        }
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            getCloseStationValue()
        default:    //거부되거나 아직 정해지지 않은 경우에는 ?만 띄웁니다.
            levelLabel.text = locError
        }
        
    }
    
    func getCloseStationValue() {
        
        
    }
    
}

