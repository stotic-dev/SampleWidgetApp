//
//  WeatherEntry.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/16.
//

import Foundation
import WidgetKit

struct WeatherEntry: TimelineEntry {
    
    let date: Date
    let configuration: ConfigurationWeatherWidgetIntent
    let id: UUID?
    let placeInfo: Landmark?
    let weatherInfo: WeatherResponse?
    
    init(date: Date,
         configuration: ConfigurationWeatherWidgetIntent,
         id: UUID? = nil,
         placeInfo: Landmark? = nil,
         weatherInfo: WeatherResponse? = nil) {
        
        self.date = date
        self.configuration = configuration
        self.id = id
        self.placeInfo = placeInfo
        self.weatherInfo = weatherInfo
    }
}

extension WeatherEntry {
    
    static func getPlaceholder() -> WeatherEntry {
        
        return WeatherEntry(date: Date(),
                            configuration: ConfigurationWeatherWidgetIntent())
    }
}
