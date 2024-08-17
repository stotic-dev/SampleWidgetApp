//
//  WeatherApiRequest.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/13.
//

import Foundation
import HttpClientLib

struct WeatherApiRequest: HttpRequest {
    
    var url = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    var params: [String : String] {
        
        var queryParams = input.queryParams
        queryParams.updateValue(Self.apiKey, forKey: "appid")
        queryParams.updateValue("jp", forKey: "lang")
        queryParams.updateValue("metric", forKey: "units")
        return queryParams
    }
    var operationQueue: DispatchQueue? = nil
    
    private let input: WeatherInputParam
    private static let apiKey = SecurityPropertyManager.shared.getValue(.weatherApiKey)!
    
    init(_ input: WeatherInputParam) {
        
        self.input = input
    }
}
