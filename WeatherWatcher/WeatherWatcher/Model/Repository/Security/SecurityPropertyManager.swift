//
//  SecurityPropertyManager.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/13.
//

import Foundation
import TextResoucesLib

class SecurityPropertyManager {
    
    static let shared = SecurityPropertyManager()
    
    private let property: PlistReader
    
    private init() {
        
        property = PlistReader(Bundle.main.path(forResource: "security", ofType: "plist")!)!
    }
}

// MARK: - public API

extension SecurityPropertyManager {
    
    func getValue(_ key: Key) -> String? {
        
        return property.getString(key.rawValue)
    }
}

// MARK: - security key definition

extension SecurityPropertyManager {
    
    enum Key: String {
        
        case weatherApiKey
    }
}
