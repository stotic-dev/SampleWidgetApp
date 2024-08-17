//
//  LocationBrowser.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/14.
//

import MapKit

protocol LocationBrowsable: Sendable {
    
    /// リクエストから位置情報を返す
    func search(_ request: MKLocalSearch.Request) async throws -> [Landmark]
}

struct LocationBrowser: LocationBrowsable {
    
    func search(_ request: MKLocalSearch.Request) async throws -> [Landmark] {
        
        return try await withCheckedThrowingContinuation { continuation in
            
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                
                guard let response = response else {
                    
                    if let error {
                        
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    continuation.resume(throwing: MKError.init(.unknown))
                    return
                }
                
                continuation.resume(returning: response.mapItems.map { Landmark(placeInfo: $0.placemark) })
            }
        }
    }
}
