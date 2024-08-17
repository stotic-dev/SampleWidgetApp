//
//  WeatherCondition.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/13.
//

enum WeatherCondition: String {
    
    case none = "none"
    case clear = "Clear"
    case clouds = "Clouds"
    case drizzle = "Drizzle"
    case rain = "Rain"
    case thunderstorm = "Thunderstorm"
    case snow = "Snow"
    case mist = "Mist"
    case tornado = "Tornado"
    case squall = "Squall"
    case ash = "Ash"
    case smoke = "Smoke"
    case haze = "Haze"
    case dust = "Dust"
    case fog = "Fog"
    case sand = "Sand"
    
    var backgroundImage: String {
        
        switch self {
            
        case .none:
            return "none"
            
        case .clear:
            return "clear"
            
        case .clouds:
            return "clouds"
            
        case .drizzle, .rain, .squall:
            return "mist"
            
        case .thunderstorm:
            return "thunderstorm"
            
        case .snow:
            return "snow"
            
        case .mist, .ash, .smoke, .haze, .dust, .fog:
            return "mist"
            
        case .tornado:
            return "tornado"
            
        case .sand:
            return "sand"
        }
    }
    
    var iconImageName: String {
        
        switch self {
            
        case .none:
            return "questionmark.app.dashed"
            
        case .clear:
            return "sun.max.fill"
            
        case .clouds:
            return "cloud.fill"
            
        case .drizzle, .rain, .squall:
            return "cloud.rain.fill"
            
        case .thunderstorm:
            return "cloud.bolt.rain.fill"
            
        case .snow:
            return "cloud.snow.fill"
            
        case .mist, .ash, .smoke, .haze, .dust, .fog:
            return "smoke.fill"
            
        case .tornado:
            return "tornado"
            
        case .sand:
            return "hurricane"
        }
    }
}
