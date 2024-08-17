//
//  RegisteredLocationRepository.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/15.
//

import CoreLocation

protocol RegisteredLocationUseCase: Sendable {
    
    /// 保存している位置情報を取得する
    func fetchAll() async throws -> [RegisteredLocation]
    
    /// 位置情報を保存する
    func saveLocation(_ location: RegisteredLocation) async throws
    
    func selectedLocation(_ id: UUID) async throws -> [RegisteredLocation]
}

struct RegisteredLocationRepository: RegisteredLocationUseCase {
    
    private let realmAccessor: RealmAccessable
    
    init(realmAccessor: RealmAccessable = RealmDb.shared) {
        
        self.realmAccessor = realmAccessor
    }
    
    @RealmDb
    func fetchAll() async throws -> [RegisteredLocation] {
        
        let result: [RegisteredLocationEntity] = try await realmAccessor.readObject({ _ in true })
        return result.map { RegisteredLocation($0) }
    }
    
    @RealmDb
    func saveLocation(_ location: RegisteredLocation) async throws {
        
        try await realmAccessor.insertObject([RegisteredLocationEntity(id: location.id,
                                                                       isSelected: location.isSelected,
                                                                       lat: location.lat,
                                                                       lon: location.lon)])
    }
    
    @RealmDb
    func selectedLocation(_ id: UUID) async throws -> [RegisteredLocation] {
        
        let result: [RegisteredLocationEntity] = try await realmAccessor.readObject({ _ in true })
        guard let selected = result.first(where: { $0.id == id }) else { return [] }
        let updatedLocations: [RegisteredLocationEntity] = try await realmAccessor.updateObject { registeredLocations in
            
            return registeredLocations.map {
                
                $0.isSelected = $0.id == selected.id
                return $0
            }
        }
        
        return updatedLocations.map { RegisteredLocation($0) }
    }
}

struct RegisteredLocation: Identifiable, Sendable {
    
    let id: UUID
    let isSelected: Bool
    let lon: Double
    let lat: Double
    
    init(id: UUID, isSelected: Bool, lon: Double, lat: Double) {
        
        self.id = id
        self.isSelected = isSelected
        self.lon = lon
        self.lat = lat
    }
    
    fileprivate init(_ realmObject: RegisteredLocationEntity) {
        
        id = realmObject.id
        isSelected = realmObject.isSelected
        lon = realmObject.lon
        lat = realmObject.lat
    }
}
