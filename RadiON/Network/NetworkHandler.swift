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
    private static let urlString: String = "https://iernet.kins.re.kr/all_site.asp"
    
    let lastFetchTime: Date?    //마지막으로 fetch한 시간을 가지고 있는다.
    
    private static let urlSession: URLSession = URLSession.shared  //Singletone, 가장 기본적이며 제한적 사항만을 가지고 있는 객체
    
    class func fetchData(completionHandler: @escaping (_ data: Data?,_ urlResponse: URLResponse?,_ error: Error?) -> Void) {    //완료 핸들러는 외부에서 클로저로 받는다. 클로저는 이 함수 내에서 실행하는게 아니라 함수가 끝난 뒤 콜백으로 실행될 것이므로 @escaping
        
        guard let url: URL = URL(string: urlString) else{
            //some error message
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
    
        let urlSessionTask: URLSessionTask = urlSession.dataTask(with: urlRequest, completionHandler: completionHandler)
        
        urlSessionTask.resume()
        
    }
    
    enum resultCode {
        case sessionStarted
        case sessionStopped
        
    }
}
