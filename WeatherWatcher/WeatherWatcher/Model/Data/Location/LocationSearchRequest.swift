//
//  LocationSearchRequest.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/14.
//

import MapKit

struct LocationSearchRequest {
    
    // 検索する地名の文字列
    private let place: String
    
    init(place: String) {
        
        self.place = place
    }
    
    // 地名検索用のリクエストオブジェクト生成
    func getLocationSearchByPlaceRequest() -> MKLocalSearch.Request {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = place
        return request
    }
}
