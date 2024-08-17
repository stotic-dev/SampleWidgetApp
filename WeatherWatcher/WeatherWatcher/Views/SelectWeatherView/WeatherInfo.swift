//
//  WeatherInfo.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/15.
//

import Foundation

struct WeatherInfo: Identifiable, Sendable {
    
    var id: UUID
    let isSelected: Bool
    private let weatherResponse: WeatherResponse
    private let location: Landmark
    
    init(id: UUID, isSelected: Bool, weatherResponse: WeatherResponse, location: Landmark) {
        
        self.id = id
        self.isSelected = isSelected
        self.weatherResponse = weatherResponse
        self.location = location
    }
    
    var temperature: Double {
        
        return weatherResponse.main.temp
    }
    
    var temperatureString: String {
        
        return String(format: "%.2f", weatherResponse.main.temp) + "°"
    }
    
    var maxTemp: Double {
        
        return weatherResponse.main.temp_max
    }
    
    var minTemp: Double {
        
        return weatherResponse.main.temp_min
    }
    
    var weatherCondition: WeatherCondition {
        
        guard let weatherConditionString = weatherResponse.weather.first?.main,
              let condition = WeatherCondition(rawValue: weatherConditionString) else { return .none }
        return condition
    }
    
    var pressure: Double {
        
        return weatherResponse.main.pressure
    }
    
    var humidity: Double {
        
        return weatherResponse.main.humidity
    }
    
    var seaLevel: Double {
        
        return weatherResponse.main.sea_level
    }
    
    var grandLevel: Double {
        
        return weatherResponse.main.grnd_level
    }
    
    var placeName: String {
        
        return location.name ?? "-"
    }
    
    func updateSelectFlg(_ isSelected: Bool) -> Self {
        
        return WeatherInfo(id: id, isSelected: isSelected, weatherResponse: weatherResponse, location: location)
    }
}

extension WeatherInfo {
    
    static func defaultMock() -> Self {
        
        return WeatherInfo(id: UUID(), isSelected: false, weatherResponse: .defaultMock(), location: .defaultMock())
    }
}
