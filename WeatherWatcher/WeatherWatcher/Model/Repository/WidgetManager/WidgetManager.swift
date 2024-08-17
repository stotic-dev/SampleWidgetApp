//
//  WidgetManager.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/16.
//

import WidgetKit

struct WidgetManager {
    
    func sendReloadRequest(_ kind: AppWidgetKind) {
        
        WidgetCenter.shared.reloadTimelines(ofKind: kind.rawValue)
    }
}

enum AppWidgetKind: String {
    
    case weather = "WeatherWidget"
}
