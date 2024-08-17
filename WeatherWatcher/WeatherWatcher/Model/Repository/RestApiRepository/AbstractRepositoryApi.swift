//
//  AbstractRepositoryApi.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/13.
//

import Foundation
import HttpClientLib

protocol AbstractRepositoryApi {
    
    associatedtype Response: Decodable
    associatedtype InputParam
        
    func execute(_ input: InputParam) async throws -> HttpClientLib.HttpResponse<Response>
    
    func getClient() -> HttpSessionable
}

extension AbstractRepositoryApi {
    
    func getClient() -> HttpSessionable {
        
        return HttpClient()
    }
}
