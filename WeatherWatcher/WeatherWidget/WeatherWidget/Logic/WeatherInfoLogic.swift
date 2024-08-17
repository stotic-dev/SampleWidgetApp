//
//  WeatherInfoLogic.swift
//  WeatherWidgetExtension
//
//  Created by 佐藤汰一 on 2024/08/16.
//

import CoreLocation
import Foundation

protocol WeatherInfoLogicInterface {
    
    func getSelectableLocations() async throws -> [RegisteredLocation]
    
    func getSelectWeatherInfo(id: UUID) async throws -> (Landmark, WeatherResponse)
}

struct WeatherInfoLogic: WeatherInfoLogicInterface {
    
    private let weatherRepository: any WeatherApiRepositoryInterface
    private let locationSearchRepository: LocationSearchUseCase
    private let registeredLocationRepository: RegisteredLocationUseCase
    private let userDefaultRepository: UserDefaultInterface
    
    init(weatherRepository: some WeatherApiRepositoryInterface = WeatherApiRepository(),
         locationSearchRepository: LocationSearchUseCase = LocationSearchRepository(),
         registeredLocationRepository: RegisteredLocationUseCase = RegisteredLocationRepository(),
         userDefaultRepository: UserDefaultInterface = UserDefaultRepository()) {
        
        self.weatherRepository = weatherRepository
        self.locationSearchRepository = locationSearchRepository
        self.registeredLocationRepository = registeredLocationRepository
        self.userDefaultRepository = userDefaultRepository
    }
    
    func getSelectableLocations() async throws -> [RegisteredLocation] {
        
        return try await registeredLocationRepository.fetchAll()
    }
    
    func getSelectWeatherInfo(id: UUID) async throws -> (Landmark, WeatherResponse) {
        
        let locations = try await registeredLocationRepository.fetchAll()
        guard let location = locations.first(where: { $0.id == id }) else {
            
            print("not found select location in realm(selectId: \(id), locations: \(locations))")
            throw MachError(.failure)
        }
        
        let landmark = try await locationSearchRepository.searchByCoordinate(CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon))
        let weatherInfo = try await weatherRepository.execute(WeatherInputParam(lon: landmark.coordinate.longitude, lat: landmark.coordinate.latitude))
        
        return (landmark, weatherInfo.data)
    }
}
