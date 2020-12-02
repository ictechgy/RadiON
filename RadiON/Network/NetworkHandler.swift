//
//  NetworkHandler.swift
//  RadiON
//
//  Created by JINHONG AN on 2020/11/21.
//

import Foundation

//서버와 통신해서 csv파일 가져오기.
//기본적으로 탭 컨트롤러가 보일 때 갱신(viewWillApear). 이후에는 별도의 새로고침 버튼으로 데이터 동기화
//viewWillAppear에 갱신 메소드를 두었으므로 dissapear뒤에 appear하는 방식으로 무한 호출이 될 경우
//불필요한 트래픽을 주게 되므로 갱신 시점 time값 가지고 있기.(새로고침도 해당 time값으로 갱신 허/불허 설정)
//오래된 데이터를 가지고 있는 경우 화면이 보일 때 time값과 현재 시각 비교 후 자동갱신 해주고 그 외에는 수동갱신으로 설정

class NetworkHandler {
    /// singletone
    static let shared: NetworkHandler = NetworkHandler()
    private init(){}
    
    private let urlString: String = "https://iernet.kins.re.kr/all_site.asp"
    private let urlSession: URLSession = URLSession.shared  //가장 기본적이며 제한적 사항만을 가지고 있는 객체

    /// 마지막으로 fetch한 시간을 가지고 있는다.
    var lastFetchTime: Date?
    
    /// 서버에서 CSV 파일을 가져와 파싱까지 하는 메소드. parameter는 완료 시 결과값을 받아 처리할 핸들러
    func fetchCSVData(resultHandler: @escaping (Result<[Station], FetchError>)->Void ) {
        
        if let lastFetchTime = lastFetchTime, lastFetchTime >= Date(timeIntervalSinceNow: -300) {   //5분 딜레이
            return resultHandler(.failure(.timeError))
        }
        
        guard let url: URL = URL(string: urlString) else{
            return resultHandler(.failure(.urlError))
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
    
        let urlSessionTask: URLSessionTask = urlSession.dataTask(with: urlRequest){ data, response, error in
            //async
            //인코딩 문제 -> 아래와 같이 해결
            guard let data = data, let csvData = String(data: data, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422))) else{
                return DispatchQueue.main.async { resultHandler(.failure(.dataTaskError(error))) }
            }
            
            var stations: [Station] = []
            
            for (index, row) in csvData.components(separatedBy: "\r\n").enumerated() {
                if index == 0 { continue }  //0번 인덱스는 각 컬럼 제목이므로 스킵
                let columns = row.components(separatedBy: ",")    //각 칼럼 구분
                if columns.count < 5 { continue }   //칼럼 개수 충족 못하는 경우 스킵
                
                var networkAndArea = columns[0]
                let endOfNetworkIndex = networkAndArea.firstIndex(of: "]")
                
                var network: String = ""
                var administrativeArea: String = ""
                if let endOfNetworkIndex = endOfNetworkIndex {
                    network = String(networkAndArea[...endOfNetworkIndex]).trimmingCharacters(in: ["[", "]"])
                    networkAndArea.removeSubrange(...endOfNetworkIndex)
                    administrativeArea = String(networkAndArea)
                }
                
                let locationName = columns[1]
                let doseEquivalent = columns[2].trimmingCharacters(in: ["=","\""])  //불필요한 특수문자 제거
                
                let exposure = columns[3]
                let status = columns[4]
                
                stations.append(
                    Station(networkDelimitation: Station.networkType(rawValue: network) ?? .unknownNetwork, administrativeArea: administrativeArea, locationName: locationName, locationLatitude: nil, locationLongitude: nil, doseEquivalent: Double(doseEquivalent) ?? 0.0, exposure: Double(exposure) ?? 0.0, status: Station.levelType(rawValue: status) ?? .unknownLevel)
                )
            }
            
            //파싱 완료 후
            return DispatchQueue.main.async { resultHandler(.success(stations)) }
        }
        
        urlSessionTask.resume()
        lastFetchTime = Date()
        
        return
    }
    
    enum FetchError: Error {
        case timeError
        case urlError
        case dataTaskError(Error?)
    }
    
}
