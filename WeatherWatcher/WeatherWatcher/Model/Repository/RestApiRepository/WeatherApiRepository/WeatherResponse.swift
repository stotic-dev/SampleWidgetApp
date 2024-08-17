//
//  WeatherResponse.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/13.
//

struct WeatherResponse: Decodable {
    
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    
    struct Coord: Decodable {
        
        let lon: Double
        let lat: Double
    }
        
    struct Weather: Decodable {
        
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Decodable {
        
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Double
        let humidity: Double
        let sea_level: Double
        let grnd_level: Double
    }
}

extension WeatherResponse {
    
    static func defaultMock() -> Self {
        
        let weather = Weather(id: 0, main: "Clear", description: "clear sky", icon: "01n")
        let main = Main(temp: 24.3, feels_like: 26.7, temp_min: 22.1, temp_max: 26.7, pressure: 12, humidity: 12, sea_level: 12, grnd_level: 12)
        return WeatherResponse(coord: Coord(lon: 135.5453195, lat: 34.6761499),
                               weather: [weather],
                               base: "sampel base",
                               main: main)
    }
}
