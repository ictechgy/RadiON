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
    /// Assets내에 있는 csv 파일을 불러온 뒤 파싱하는 메소드
    func getLocalData() -> Result<Dictionary<String, (Double, Double)>, AssetError> {    //Result enum 사용하자.
        //Asset의 csv load
        
        //network 데이터를 local data와 합쳐서 위경도 설정
        let dataAsset: NSDataAsset? = NSDataAsset(name: "national_coordinates_utf8")
        //NSDataAsset으로는 잘 가져와진다. data프로퍼티에도 잘 들어가있다. String으로 변환하는 과정의 문제일까 아니면 파일을 다른 방식으로 가져와야 할까?
        //파일을 별도로 utf8 형식으로 저장 후 인코딩 타입을 utf8로 지정하여 해결하였다. 기존 파일은 euc-kr로 저장되어있었던 것으로 예상
        
        guard let localCSVData = dataAsset?.data, let localData = String(data: localCSVData, encoding: .utf8) else {
            return Result.failure(.assetsLoadError)
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
    
    /// Assets에 있는 파일과 서버에서 받은 파일을 합치는 메소드
    func mergeData(localData coordData: Dictionary<String, (Double, Double)>, fetchedData stations: inout [Station]) -> [Station] {  //local Data + network fetched Data
        for (index, var station) in stations.enumerated() {
            let coord: (Double, Double) = coordData[station.locationName] ?? (0.0, 0.0)
            
            station.locationLatitude = coord.0
            station.locationLongitude = coord.1
            stations[index] = station
        }
        
        return stations
    }
    
    enum AssetError: Error {
        case assetsLoadError
    }
}
