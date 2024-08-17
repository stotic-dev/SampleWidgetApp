//
//  WeatherWatcherApp.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/13.
//

import SwiftUI
import WidgetKit

@main
struct WeatherWatcherApp: App {
    
    private let widgetManager = WidgetManager()
    private let appState = AppStatus()
    
    var body: some Scene {
        WindowGroup {
            SelectWeatherView(viewModel: SelectWeatherViewModel())
                .environmentObject(appState)
                .onAppear {
                    widgetManager.sendReloadRequest(.weather)
                }
                .onOpenURL { url in
                    print("open from [\(url)]")
                    appState.openAppUrl = OpenUrl(url: url)
                }
        }
    }
}
