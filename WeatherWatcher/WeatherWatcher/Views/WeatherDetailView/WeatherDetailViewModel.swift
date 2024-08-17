//
//  WeatherDetailViewModel.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/15.
//

import Foundation
import SwiftUI

@MainActor
class WeatherDetailViewModel: ObservableObject {
    
    let weatherInfo: WeatherInfo
    
    var placeName: String {
        
        return weatherInfo.placeName
    }
    
    var temperature: String {
        
        return getMetricUnitValue(weatherInfo.temperature)
    }
    
    var maxTemperature: String {
        
        return getMetricUnitValue(weatherInfo.maxTemp)
    }
    
    var minTemperature: String {
        
        return getMetricUnitValue(weatherInfo.minTemp)
    }
    
    var backGroundImage: String {
        
        return weatherInfo.weatherCondition.backgroundImage
    }
    
    init(weatherInfo: WeatherInfo) {
        
        self.weatherInfo = weatherInfo
    }
}

enum WeatherDetailType: CaseIterable {
    
    case pressure
    case humidity
    case seaLevel
    case grandLevel
    
    var title: String {
        
        switch self {
            
        case .pressure:
            return "気圧"
            
        case .humidity:
            return "湿度"
            
        case .seaLevel:
            return "海面"
            
        case .grandLevel:
            return "地面盤"
        }
    }
    
    var icon: Image {
        
        switch self {
            
        case .pressure:
            return Image(systemName: "aqi.low")
            
        case .humidity:
            return Image(systemName: "humidity")
            
        case .seaLevel:
            return Image(systemName: "water.waves")
            
        case .grandLevel:
            return Image(systemName: "globe.americas")
        }
    }
    
    func getValue(_ weatherInfo: WeatherInfo) -> String {
        
        switch self {
            
        case .pressure:
            return String(weatherInfo.pressure)
            
        case .humidity:
            return String(weatherInfo.humidity)
            
        case .seaLevel:
            return String(weatherInfo.seaLevel)
            
        case .grandLevel:
            return String(weatherInfo.grandLevel)
        }
    }
}

private extension WeatherDetailViewModel {
    
    func getMetricUnitValue(_ temperature: Double) -> String {
        
        return String(format: "%.1f", temperature) + "°"
    }
}
