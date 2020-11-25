//
//  AssetsLoader.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/25.
//

import Foundation

class AssetsLoader {
    static let shared = AssetsLoader()
    private init() {}
    
    func loadData() -> Result {
        //Asset의 csv load
        
        //network 데이터를 local data와 합쳐서 위경도 설정
        guard let localURL: URL = URL(string: "national_coordinates.csv") else {
            return
        }
        
        guard let localCSVData: Data = try? Data(contentsOf: localURL) else {
            return
        }
        let localData = String(data: localCSVData, encoding: .utf8)
        
        var dictionary: [String: (Double, Double)] = [:] //각 지역 값에 맞춰 위경도를 넣을 것이다. 키 값은 지역이름, 밸류값은 각각 위도와 경도를 의미
        //키 값이 String인데 이는 Hashable이므로 검색시간은 O(1)
        
    }
}
