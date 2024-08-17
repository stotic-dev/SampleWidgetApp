//
//  AppStatus.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/16.
//

import Foundation

class AppStatus: ObservableObject {
    
     @Published var openAppUrl: OpenUrl = .none
}

enum OpenUrl: CaseIterable {
    
    static var allCases: [OpenUrl] { return [.none, .weatherWidget(id: nil)] }
    
    case none
    case weatherWidget(id: String?)
    
    init(url: URL) {
        
        guard let openUrl = Self.allCases.first(where: { $0.scheme == url.scheme && $0.host == url.host() }) else {
            
            self = .none
            return
        }
        
        switch openUrl {
            
        case .none:
            self = .none
            
        case .weatherWidget:
            self = .weatherWidget(id: URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first?.value)
        }
    }
    
    var url: String? {
        
        switch self {
            
        case .none:
            return nil
            
        case .weatherWidget:
            return "widget-link://weather"
        }
    }
    
    var scheme: String? {
        
        switch self {
            
        case .none:
            return nil
            
        case .weatherWidget:
            return "widget-link"
        }
    }
    
    var host: String? {
        
        switch self {
            
        case .none:
            return nil
            
        case .weatherWidget:
            return "weather"
        }
    }
}
