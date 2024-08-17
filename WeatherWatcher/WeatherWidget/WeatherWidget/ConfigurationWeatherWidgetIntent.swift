//
//  ConfigurationWeatherWidgetIntent.swift
//  SampleWidget
//
//  Created by 佐藤汰一 on 2024/08/13.
//

import WidgetKit
import AppIntents

struct ConfigurationWeatherWidgetIntent: WidgetConfigurationIntent {
    
    static var title: LocalizedStringResource = "位置の設定"
    
    @Parameter(title: "現在の設定")
    var location: WeatherWidgetIntentEntity
}

struct WeatherWidgetIntentEntity: AppEntity {
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "location"
        
    var id: UUID {
        
        return location.id
    }
    
    var location: RegisteredLocation
    var locationName: String?
    
    var displayRepresentation: DisplayRepresentation {
        
        return DisplayRepresentation(stringLiteral: locationName ?? "その他の地域")
    }
    
    static var defaultQuery = WeatherWidgetIntentQuery()
    
    @Property(title: "locationName")
    var name: String
}

struct WeatherWidgetIntentQuery: EntityQuery {
    
    private let registeredLocationRepository: RegisteredLocationUseCase
    private let locationSearchRepository: LocationSearchUseCase
    
    init() {
        
        registeredLocationRepository = RegisteredLocationRepository()
        locationSearchRepository = LocationSearchRepository()
    }
    
    func entities(for identifiers: [WeatherWidgetIntentEntity.ID]) async throws -> [WeatherWidgetIntentEntity] {
        
        let registeredLocations = try await registeredLocationRepository.fetchAll()
        let landMarks = try await locationSearchRepository.searchByCoordinates(registeredLocations.map { .init(latitude: $0.lat, longitude: $0.lon) })
        print("entities: \(landMarks)")
        return registeredLocations.map { registeredLocation in
            
            WeatherWidgetIntentEntity(location: registeredLocation,
                                      locationName: landMarks.first { $0.isSameLocation(lon: registeredLocation.lon, lat: registeredLocation.lat) }?.name)
        }
    }
    
    func suggestedEntities() async throws -> [WeatherWidgetIntentEntity] {
        
        let registeredLocations = try await registeredLocationRepository.fetchAll()
        let landMarks = try await locationSearchRepository.searchByCoordinates(registeredLocations.map { .init(latitude: $0.lat, longitude: $0.lon) })
        print("suggestedEntities: \(landMarks)")
        return registeredLocations.map { registeredLocation in
            
            WeatherWidgetIntentEntity(location: registeredLocation,
                                      locationName: landMarks.first { $0.isSameLocation(lon: registeredLocation.lon, lat: registeredLocation.lat) }?.name)
        }
    }
}
