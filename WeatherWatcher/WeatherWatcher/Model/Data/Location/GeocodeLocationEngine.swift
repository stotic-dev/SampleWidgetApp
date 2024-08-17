//
//  GeocodeLocationEngine.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/15.
//

import CoreLocation

protocol LocationGeocodeble: Sendable {
    
    func reverseGeocode(lon: Double, lat: Double) async throws -> Landmark
}

struct GeocodeLocationEngine: LocationGeocodeble {
    
    func reverseGeocode(lon: Double, lat: Double) async throws -> Landmark {
        
        return try await withCheckedThrowingContinuation { continuation in
            
            let location = CLLocation(latitude: lat, longitude: lon)
            CLGeocoder().reverseGeocodeLocation(location) { placeMarks, error in
                
                guard let placeMarks = placeMarks,
                      let placeMark = placeMarks.first else {
                    
                    if let error {
                        
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    continuation.resume(throwing: CLError.init(.geocodeFoundNoResult))
                    return
                }
                
                continuation.resume(returning: Landmark(placeInfo: placeMark))
            }
        }
    }
}
