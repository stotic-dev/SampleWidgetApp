//
//  SelectWeatherViewModel.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/15.
//

import Combine
import CoreLocation
import Foundation
import SwiftUI

@MainActor
class SelectWeatherViewModel: ObservableObject {
    
    enum Path: Hashable {
        
        case detail(UUID)
    }
    
    @Published var isPresented = false
    @Published var isLoading = false
    @Published var weathers: [WeatherInfo] = []
    var path = NavigationPath()
    var delegateViewModel = SearchLocationViewModel.DelegateViewModel()
    var locations: [RegisteredLocation] = [] {
        
        didSet {
            
            guard let selectedId = locations.first(where: { $0.isSelected })?.id else { return }
            
            // 選択中の位置を保存
            userDefaultRepository.setValue(.currentSelectingLocation, value: selectedId.uuidString)
            let savedId: String? = userDefaultRepository.getValue(.currentSelectingLocation)
            print("saved selectedId(\(String(describing: savedId)))")
            
            // ViewStateの選択フラグ更新
            weathers = weathers.map {
                
                return $0.updateSelectFlg($0.id == selectedId ? true : false)
            }
        }
    }
    
    private var cancellable: AnyCancellable?
    private var initialTask: Task<Void, Never>?
    
    private let weatherRepository: any WeatherApiRepositoryInterface
    private let locationSearchRepository: LocationSearchUseCase
    private let registeredLocationRepository: RegisteredLocationUseCase
    private let userDefaultRepository: UserDefaultInterface
    
    init(weathers: [WeatherInfo] = [],
         weatherRepository: some WeatherApiRepositoryInterface = WeatherApiRepository(),
         locationSearchRepository: LocationSearchUseCase = LocationSearchRepository(),
         registeredLocationRepository: RegisteredLocationUseCase = RegisteredLocationRepository(),
         userDefaultRepository: UserDefaultInterface = UserDefaultRepository()) {
        
        self.weathers = weathers
        self.weatherRepository = weatherRepository
        self.locationSearchRepository = locationSearchRepository
        self.registeredLocationRepository = registeredLocationRepository
        self.userDefaultRepository = userDefaultRepository
    }
    
    func onAppear() {
        
        addObserveSelectLocation()
        
        if initialTask != nil { return }
        
        initialTask = Task {
            
            isLoading = true
            await fetchWeatherInfoFromRegisteredData()
            isLoading = false
        }
    }
    
    func tappedAddLocationButton() {
        
        delegateViewModel.selectLocation = nil
        isPresented = true
    }
    
    func receivedOpenUrl(_ openUrl: OpenUrl) {
        
        guard case .weatherWidget(let id) = openUrl else { return }
            
        Task {
            
            if initialTask == nil {
                
                initialTask = initialSettingTask()
            }
            
            await initialTask?.value
            guard let id = locations.first(where: { $0.id.uuidString == id })?.id else { 
                
                print("not found destination(id=\(String(describing: id)))")
                return
            }
            path.append(Path.detail(id))
            print("append navigation path(id: \(id)")
        }
    }
}

private extension SelectWeatherViewModel {
    
    func addObserveSelectLocation() {
        
        cancellable = self.delegateViewModel.$selectLocation.receive(on: DispatchQueue.main).sink { [weak self] landmark in
            
            guard let self = self,
                  let landmark = landmark else { return }
            print("receive select location event(\(landmark)).")
            self.addWeather(landmark)
        }
    }
    
    func initialSettingTask() -> Task<Void, Never> {
        
        return Task {
            
            isLoading = true
            await fetchWeatherInfoFromRegisteredData()
            isLoading = false
        }
    }
        
    func fetchWeatherInfo(id: UUID, location: Landmark) async throws -> WeatherInfo {
        
        print("start sendWeatherApi")
        let input = WeatherInputParam(lon: location.coordinate.longitude, lat: location.coordinate.latitude)
        let result = try await weatherRepository.execute(input)
        print("success sendWeatherApi(\(result))")
        return WeatherInfo(id: id, isSelected: false, weatherResponse: result.data, location: location)
    }
    
    func fetchWeatherInfoFromRegisteredData() async {
        
        print("start fetchWeatherInfoFromRegisteredData")
        do {
            
            locations = try await registeredLocationRepository.fetchAll()
            print("did fetch saved locations(\(locations))")
            
            let landmarks = try await locationSearchRepository.searchByCoordinates(locations.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon) })
            print("did geocode(\(landmarks))")
            
            let weatherResponses = try await weatherRepository.execute(landmarks.map { WeatherInputParam(lon: $0.coordinate.longitude, lat: $0.coordinate.latitude) })
            print("did request weather api(\(weatherResponses))")
            
            weathers = weatherResponses.enumerated().compactMap {
                
                guard landmarks.indices.contains($0) else { return nil }
                let landmark = landmarks[$0]
                
                guard let location = locations.first(where: { $0.lat == landmark.coordinate.latitude && $0.lon == landmark.coordinate.longitude }) else {
                    
                    print("no exists registeredLocation(landmark=\(landmark))")
                    return nil
                }
                
                guard let responseData = try? $1.get().data else {
                    
                    print("fail weather api(location=\(landmark))")
                    return nil
                }
                return WeatherInfo(id: location.id,
                                   isSelected: location.isSelected,
                                   weatherResponse: responseData,
                                   location: landmark)
            }
        }
        catch {
            
            print("failed fetch registered locations(error: \(error)).")
        }
        
        print("end fetchWeatherInfoFromRegisteredData")
    }
    
    func addWeather(_ location: Landmark) {
        
        print("start sendWeatherApi")
        
        if locations.contains(where: { location.isSameLocation(lon: $0.lon, lat: $0.lat) }) {
            
            print("already exists same location(add: \(location), registered: \(locations))")
            return
        }
        
        isLoading = true
        Task {
            do {
                
                let newLocationId = UUID()
                try await self.registeredLocationRepository.saveLocation(RegisteredLocation(id: newLocationId,
                                                                                            isSelected: false,
                                                                                            lon: location.coordinate.longitude,
                                                                                            lat: location.coordinate.latitude))
                weathers.append(try await fetchWeatherInfo(id: newLocationId, location: location))
                locations = try await registeredLocationRepository.selectedLocation(newLocationId)
            }
            catch {
                
                print("error: \(error)")
            }
            
            isLoading = false
            print("end sendWeatherApi")
        }
    }
}
