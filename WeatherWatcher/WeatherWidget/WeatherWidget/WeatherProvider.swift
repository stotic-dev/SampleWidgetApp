//
//  WeatherProvider.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/16.
//

import CoreLocation
import Foundation
import WidgetKit

struct WeatherProvider: AppIntentTimelineProvider {
    
    private let weatherInfoLogic: WeatherInfoLogicInterface
    
    init(weatherInfoLogic: WeatherInfoLogicInterface = WeatherInfoLogic()) {
        
        self.weatherInfoLogic = weatherInfoLogic
    }
    
    func placeholder(in context: Context) -> WeatherEntry {
        
        print("placeholder(isPreview: \(context.isPreview), family: \(context.family))")
        return WeatherEntry(date: Date(), configuration: ConfigurationWeatherWidgetIntent())
    }
    
    func snapshot(for configuration: ConfigurationWeatherWidgetIntent, in context: Context) async -> WeatherEntry {
        
        print("snapshot [In]")
        do {
            
            let weatherInfo = try await weatherInfoLogic.getSelectWeatherInfo(id: configuration.location.id)
            print("snapshot did fetch weatherInfo(\(weatherInfo))")
            return WeatherEntry(date: Date(),
                                configuration: configuration,
                                id: configuration.location.id,
                                placeInfo: weatherInfo.0,
                                weatherInfo: weatherInfo.1)
        }
        catch {
            
            print("failed create snapshot(\(error))")
            return .getPlaceholder()
        }
    }
    
    func timeline(for configuration: ConfigurationWeatherWidgetIntent, in context: Context) async -> Timeline<WeatherEntry> {
        
        print("timeline start(currentConfig=(id: \(configuration.location.id), location: \(configuration.location.locationName)))")
        let currentDate = Date()
        var entry: WeatherEntry = .getPlaceholder()
        
        do {
            
            let weatherInfo = try await weatherInfoLogic.getSelectWeatherInfo(id: configuration.location.id)
            print("timeline did fetch weatherInfo(\(weatherInfo))")
            entry = WeatherEntry(date: Date(),
                                 configuration: configuration,
                                 id: configuration.location.id,
                                 placeInfo: weatherInfo.0,
                                 weatherInfo: weatherInfo.1)
        }
        catch {
            
            print("failed create timeline entry(\(error))")
        }
        let nextReloadDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)
        
        print("timeline end(nextReloadDate: \(String(describing: nextReloadDate)))")
        return Timeline(entries: [entry], policy: .after(nextReloadDate ?? Date()))
    }
}
