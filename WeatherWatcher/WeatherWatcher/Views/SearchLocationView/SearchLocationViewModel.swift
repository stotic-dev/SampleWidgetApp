//
//  SearchLocationViewModel.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/15.
//

import Foundation

@MainActor
class SearchLocationViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var discoveredLocation: [Landmark] = []
    @Published var isLoading = false
    var delegateViewModel: DelegateViewModel?
    
    class DelegateViewModel: ObservableObject {
        
        @Published var selectLocation: Landmark?
    }
    
    private let locationRepository: LocationSearchUseCase
    
    init(delegate: DelegateViewModel, locationRepository: LocationSearchUseCase = LocationSearchRepository()) {
        
        self.delegateViewModel = delegate
        self.locationRepository = locationRepository
    }
    
    func tappedSearchButton(_ place: String) {
        
        isLoading = true
        
        Task { [searchText] in
            
            do {
                
                self.discoveredLocation = try await locationRepository.searchByPlaceText(searchText)
            }
            catch {
                
                print("fail fetch location(error: \(error))")
            }
            
            isLoading = false
        }
    }
    
    func tappedLocationRow(_ location: Landmark) {
        
        delegateViewModel?.selectLocation = location
    }
}
