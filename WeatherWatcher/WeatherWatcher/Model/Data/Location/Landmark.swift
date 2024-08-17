//
//  Landmark.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/14.
//

import MapKit

struct Landmark: Identifiable {
        
    init(placeInfo: MKPlacemark) {
        
        self.name = placeInfo.name
        self.address = placeInfo.thoroughfare
        self.country = placeInfo.country
        self.coordinate = placeInfo.coordinate
    }
    
    init(placeInfo: CLPlacemark) {
        
        let mkPlaceMark = MKPlacemark(placemark: placeInfo)
        self.name = mkPlaceMark.name
        self.address = mkPlaceMark.thoroughfare
        self.country = mkPlaceMark.country
        self.coordinate = mkPlaceMark.coordinate
    }
    
    init(name: String, address: String, country: String, lon: Double, lat: Double) {
        
        self.name = name
        self.address = address
        self.country = country
        self.coordinate = CLLocationCoordinate2D(latitude: lon, longitude: lat)
    }
    
    var id: String {
        
        return "\(coordinate.latitude)\(coordinate.longitude)"
    }
    
    var name: String?
    
    var address: String?
    
    var country: String?
    
    var coordinate: CLLocationCoordinate2D
    
    func isSameLocation(lon: Double, lat: Double) -> Bool {
        
        return coordinate.longitude == lon && coordinate.latitude == lat
    }
}

extension Landmark {
    
    static func defaultMock() -> Self {
        
        return Landmark(name: "東成区",
                        address: "大阪市東成区東中本",
                        country: "日本",
                        lon: 135.5453195,
                        lat: 34.6761499)
    }
}
