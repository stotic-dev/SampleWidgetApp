//
//  LocationSearchRepository.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/14.
//

import MapKit

protocol LocationSearchUseCase: Sendable {
    
    /// 地名のテキストで位置情報を検索する
    func searchByPlaceText(_ place: String) async throws -> [Landmark]
    
    /// 座標から位置情報を検索する
    func searchByCoordinate(_ coordinate: CLLocationCoordinate2D) async throws -> Landmark
    
    /// 複数の座標を位置情報検索する
    func searchByCoordinates(_ coordinates: [CLLocationCoordinate2D]) async throws -> [Landmark]
}

struct LocationSearchRepository: LocationSearchUseCase {
    
    private let browser: LocationBrowsable
    private let geocoder: LocationGeocodeble
    
    init(browser: LocationBrowsable = LocationBrowser(), geocoder: LocationGeocodeble = GeocodeLocationEngine()) {
        
        self.browser = browser
        self.geocoder = geocoder
    }
    
    func searchByPlaceText(_ place: String) async throws -> [Landmark] {
        
        let request = LocationSearchRequest(place: place)
        return try await browser.search(request.getLocationSearchByPlaceRequest())
    }
    
    func searchByCoordinate(_ coordinate: CLLocationCoordinate2D) async throws -> Landmark {
        
        return try await geocoder.reverseGeocode(lon: coordinate.longitude, lat: coordinate.latitude)
    }
    
    func searchByCoordinates(_ coordinates: [CLLocationCoordinate2D]) async throws -> [Landmark] {
        
        let stream: AsyncStream<Result<Landmark, Error>> = AsyncStream { stream in
            
            Task {
                do {
                    for coordinate in coordinates {
                        
                        let landmark = try await searchByCoordinate(coordinate)
                        stream.yield(.success(landmark))
                    }
                }
                catch {
                    stream.yield(.failure(error))
                }
                stream.finish()
            }
        }
        
        var results = [Landmark]()
        
        for await result in stream {
            
            switch result {
                
            case .success(let landmark):
                results.append(landmark)
                
            case .failure(let error):
                print("fail geocode(error: \(error))")
            }
        }
        
        return results
    }
}
