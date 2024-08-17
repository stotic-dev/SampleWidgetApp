//
//  UserDefaultRepository.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/16.
//

import Foundation

protocol UserDefaultInterface: Sendable {
    
    func getValue<Value>(_ key: UserDefaultKey) -> Value? where Value: UserDefaultStorable
    
    func setValue<Value>(_ key: UserDefaultKey, value: Value) where Value: UserDefaultStorable
}

struct UserDefaultRepository: UserDefaultInterface {
    
    private let storage = UserDefaults(suiteName: "group.taichi.satou.WeatherWatcher")
    
    func getValue<Value>(_ key: UserDefaultKey) -> Value? where Value: UserDefaultStorable {
        
        return storage?.value(forKey: key.rawValue) as? Value
    }
    
    func setValue<Value>(_ key: UserDefaultKey, value: Value) where Value: UserDefaultStorable {
        
        storage?.setValue(value, forKey: key.rawValue)
    }
}

enum UserDefaultKey: String {
    
    case currentSelectingLocation
}

protocol UserDefaultStorable {}

extension String: UserDefaultStorable {}
