//
//  NetworkManager.swift
//  VeterinaryApp
//
//  Created by Tanmay on 12/04/23.
//

import Foundation

protocol APIClient {
    func performURLSessionRequest<T: Codable>(with request: APIRequest, completionHandler: @escaping (Result<T, APIError>) -> Void)}

final class NetworkManager: APIClient {
    
    static var shared = NetworkManager()
    private var networkReachabilityManager = NetworkReachabilityManagerService()
    private init() {}
    
    
    private lazy var manager: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = TimeInterval(180)
        configuration.timeoutIntervalForResource = TimeInterval(180)
        
        let sessionManager = URLSession(configuration: configuration)
        
        return sessionManager
    }()
}

extension NetworkManager {
    func performURLSessionRequest<T>(with request: APIRequest, completionHandler: @escaping (Result<T, APIError>) -> Void) where T: Decodable, T: Encodable {
        if networkReachabilityManager.isReachable() {
            guard let url = URL(string: request.path) else {
                completionHandler(.failure(.apiError(reason: "URL creation failed")))
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.method
            urlRequest.allHTTPHeaderFields = request.headers
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest) { (data, response, error) in
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(.failure(.unknown))
                    return
                }
                
                if let error = error {
                    completionHandler(.failure(.apiError(reason: error.localizedDescription)))
                    return
                }
                
                guard response.statusCode == HTTPStatusCodes.ok.rawValue else {
                    if response.statusCode == HTTPStatusCodes.unauthorized.rawValue {
                        completionHandler(.failure(.apiError(reason: "Unauthorised")))
                    }
                    completionHandler(.failure(.unknownStatusCode(error: response.description)))
                    return
                }
                
                guard let data = data else {
                    completionHandler(.failure(.unknown))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data,
                                                                options: .mutableContainers) as? [String: Any]
                    print("JSON String -> \n \(json ?? [:])")
                } catch let error {
                    print(error.localizedDescription.debugDescription)
                }
                
                if let decodedObject = JsonParser().parseJson(type: T.self,
                                                              data: data) {
                    completionHandler(.success(decodedObject))
                } else {
                    completionHandler(.failure(.unknown))
                }
            }
            task.resume()
        } else {
            completionHandler(.failure(.apiError(reason: "No Internet")))
        }
    }
}
