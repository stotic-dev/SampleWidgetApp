// The Swift Programming Language
// https://docs.swift.org/swift-book

import Alamofire
import Foundation

public protocol HttpSessionable {
    
    func getRequest<Response>(_ request: HttpRequest) async throws -> HttpResponse<Response>
}

public struct HttpClient: HttpSessionable {
    
    public init() {}
    
    public func getRequest<Response>(_ request: HttpRequest) async throws -> HttpResponse<Response> {
        
        return try await doGetHttpRequest(request)
    }
}

public protocol HttpRequest {
    
    var url: URL { get }
    var params: [String: String] { get }
    var operationQueue: DispatchQueue? { get }
}

public struct HttpResponse<Data: Decodable> {
    
    public let data: Data
}

private extension HttpClient {
    
    static let defaultOperationQueue = DispatchQueue(label: "com.HttpClientLib.default.queue", attributes: .concurrent)
    static let jsonDecoder = JSONDecoder()
    
    func doGetHttpRequest<ResponseData>(_ request: HttpRequest) async throws -> HttpResponse<ResponseData> where ResponseData: Decodable {
        
        return try await withCheckedThrowingContinuation { continuation in
            
            AF.request(request.url,
                       method: .get,
                       parameters: request.params)
            .validate(statusCode: 200..<300)
            .response(queue: request.operationQueue ?? Self.defaultOperationQueue) { response in
                
                print("request url: \(response.request?.url)")
                switch response.result {
                
                case .success(let data):
                    guard let data = data else {
                        
                        continuation.resume(throwing: AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
                        return
                    }
                    do {
                        
                        let decodedData = try Self.jsonDecoder.decode(ResponseData.self, from: data)
                        return continuation.resume(returning: HttpResponse(data: decodedData))
                    }
                    catch {
                        
                        continuation.resume(throwing: AFError.responseSerializationFailed(reason: .decodingFailed(error: error)))
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
