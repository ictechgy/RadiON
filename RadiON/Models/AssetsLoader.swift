//
//  AssetsLoader.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/25.
//

import Foundation
import UIKit.NSDataAsset

class AssetsLoader {
    static let shared = AssetsLoader()
    private init() {}
        
    //로컬 데이터 가져오는 것이므로 일단 동기(Sync)적으로 작동하도록 작성
    func getLocalData() -> Result<Dictionary<String, (Double, Double)>, Error> {    //Result enum 사용하자.
        //Asset의 csv load
        
        //network 데이터를 local data와 합쳐서 위경도 설정
        let dataAsset: NSDataAsset? = NSDataAsset(name: "national_coordinates")
        //NSDataAsset으로는 잘 가져와진다. data프로퍼티에도 잘 들어가있다. String으로 변환하는 과정의 문제일까 아니면 파일을 다른 방식으로 가져와야 할까?
        
        guard let localCSVData = dataAsset?.data, let localData = String(data: localCSVData, encoding: .utf8) else {
            return Result.failure(NSError())    //변경 필요
        }
        
        var dictionary: [String: (Double, Double)] = [:] //각 지역 값에 맞춰 위경도를 넣을 것이다. 키 값은 지역이름, 밸류값은 각각 위도와 경도를 의미
        //키 값이 String인데 이는 Hashable이므로 검색시간은 O(1)
        
        for (index, row) in localData.components(separatedBy: "\r\n").enumerated() {
            if index == 0 { continue }  //column 정보 값 스킵
            let columns = row.components(separatedBy: ",")
            
            let locName: String = columns[1]
            let latitude: Double = Double(columns[2]) ?? 0.0
            let longitude: Double = Double(columns[3]) ?? 0.0
            
            dictionary.updateValue((latitude, longitude), forKey: locName)
        }
        
        return Result.success(dictionary)
    }
    
    func mergeData(localData coordData: Dictionary<String, (Double, Double)>,fetchedData stations: [Station]) -> [Station] {  //local Data + network fetched Data
        for var station in stations {
            let coord: (Double, Double) = coordData[station.locationName] ?? (0.0, 0.0)
            
            station.locationLatitude = coord.0
            station.locationLongitude = coord.1
        }
        
        return stations
    }
}
