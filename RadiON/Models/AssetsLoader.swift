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
        
    //로컬 데이터 가져오는 것이므로 일단 동기(Sync)적으로 작동하도록 작성
    func getLocalData() -> Result<Dictionary<String, (Double, Double)>, Error> {    //Result enum 사용하자.
        //Asset의 csv load
        
        //network 데이터를 local data와 합쳐서 위경도 설정
        guard let localURL: URL = URL(string: "national_coordinates.csv"), let localCSVData: Data = try? Data(contentsOf: localURL), let localData = String(data: localCSVData, encoding: .utf8) else {
            return Result.failure(NSError())
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
