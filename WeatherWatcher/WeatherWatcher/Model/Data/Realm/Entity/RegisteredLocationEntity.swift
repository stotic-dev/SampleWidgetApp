//
//  RegisteredLocationEntity.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/15.
//

import Foundation
import RealmSwift

class RegisteredLocationEntity: Object {
    
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var isSelected: Bool
    @Persisted var lat: Double
    @Persisted var lon: Double
    
    convenience init(id: UUID, isSelected: Bool, lat: Double, lon: Double) {
        
        self.init()
        self.id = id
        self.isSelected = isSelected
        self.lat = lat
        self.lon = lon
    }
}
