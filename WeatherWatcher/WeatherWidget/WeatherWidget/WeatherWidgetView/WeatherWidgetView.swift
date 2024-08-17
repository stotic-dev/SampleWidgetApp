//
//  WeatherWidgetView.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/15.
//

import SwiftUI
import WidgetKit

struct WeatherWidgetView: View {
    
    private var id: UUID?
    private var placeInfo: Landmark?
    private var weatherInfo: WeatherResponse?
    
    init(id: UUID? = nil, placeInfo: Landmark? = nil, weatherInfo: WeatherResponse? = nil) {
        
        self.id = id
        self.placeInfo = placeInfo
        self.weatherInfo = weatherInfo
    }
    
    var body: some View {
        if let placeInfo = self.placeInfo {
            VStack {
                Text(placeInfo.name ?? "-")
                if weatherInfo != nil {
                    createWeatherInfoArea()
                }
                else {
                    Text("天気情報を取得中")
                }
                Text("id: \(id?.uuidString ?? "-")")
            }
        }
        else {
            createWidgetWithNoneInfo()
        }
    }
}

private extension WeatherWidgetView {
    
    func createWidgetWithNoneInfo() -> some View {
        VStack {
            Text("天気情報を取得中")
            Text("しばらく経ってからご利用ください")
        }
    }
    
    func createWeatherInfoArea() -> some View {
        HStack {
            Text(getTemp())
                .font(.system(size: 24, weight: .bold))
            Spacer()
                .frame(width: 20)
            Image(systemName: getWeatherCondition().iconImageName)
                .resizable()
                .frame(width: 30, height: 30)
        }
        .widgetURL(URL(string: "widget-link://weather?id=\(id?.uuidString ?? "")"))
    }
    
    func getTemp() -> String {
        
        return String(format: "%.2f", weatherInfo?.main.temp ?? "-") + "°"
    }
    
    func getWeatherCondition() -> WeatherCondition {
        
        return WeatherCondition(rawValue: weatherInfo?.weather.first?.main ?? "") ?? .none
    }
}

#Preview {
    VStack {
        WeatherWidgetView()
        WeatherWidgetView(placeInfo: .defaultMock())
    }
}
