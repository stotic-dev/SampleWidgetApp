//
//  WeatherApiRepository.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/13.
//

import HttpClientLib

protocol WeatherApiRepositoryInterface: AbstractRepositoryApi where Response == WeatherResponse, InputParam == WeatherInputParam {
    
    func execute(_ input: WeatherInputParam) async throws -> HttpResponse<WeatherResponse>
    
    func execute(_ inputs: [WeatherInputParam]) async throws -> [Result<HttpResponse<WeatherResponse>, Error>]
}

struct WeatherApiRepository: WeatherApiRepositoryInterface {
    
    func execute(_ input: WeatherInputParam) async throws -> HttpResponse<WeatherResponse> {
        
        return try await getClient().getRequest(WeatherApiRequest(input))
    }
    
    func execute(_ inputs: [WeatherInputParam]) async throws -> [Result<HttpResponse<WeatherResponse>, Error>] {
        
        if inputs.isEmpty { return [] }
        
        let stream: AsyncStream<Result<HttpResponse<WeatherResponse>, Error>> = AsyncStream { stream in
            
            Task {
                
                do {
                    
                    for input in inputs {
                        
                        stream.yield(.success(try await getClient().getRequest(WeatherApiRequest(input))))
                    }
                }
                catch {
                    
                    stream.yield(.failure(error))
                }
                
                stream.finish()
            }
        }
        
        var results = [Result<HttpResponse<WeatherResponse>, Error>]()
        
        for await result in stream {
            
            results.append(result)
        }
        
        return results
    }
}

struct WeatherInputParam {
    
    let lon: Double
    let lat: Double
    
    var queryParams: [String: String] {
        
        return ["lon": String(lon), "lat": String(lat)]
    }
}
