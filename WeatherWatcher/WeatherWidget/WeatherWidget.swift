//
//  WeatherWidget.swift
//  SampleWidget
//
//  Created by 佐藤汰一 on 2024/08/13.
//

import WidgetKit
import SwiftUI

struct WeatherWidgetEntryView : View {
    
    var entry: WeatherProvider.Entry

    var body: some View {
        WeatherWidgetView(id: entry.id,
                          placeInfo: entry.placeInfo,
                          weatherInfo: entry.weatherInfo)
    }
}

struct WeatherWidget: Widget {
    
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationWeatherWidgetIntent.self, provider: WeatherProvider()) { entry in
            WeatherWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies(supportFamilies)
        .configurationDisplayName("Weather Widget")
        .description("選択している地域の天気を表示するWidget")
    }
    
    private var supportFamilies: [WidgetFamily] {
        
        if #available(iOSApplicationExtension 16.0, *) {
            return [
                .systemSmall,
                .systemMedium,
                .systemLarge,
                .systemExtraLarge,
                .accessoryInline,
                .accessoryCircular,
                .accessoryRectangular
            ]
        } else {
            return [
                .systemSmall,
                .systemMedium,
                .systemLarge
            ]
        }
    }
}

#Preview(as: .systemMedium) {
    WeatherWidget()
} timeline: {
    WeatherEntry(date: .now, configuration: .init())
}
