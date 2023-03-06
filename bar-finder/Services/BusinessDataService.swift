//
//  BusinessDataService.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import Foundation

final class BusinessDataService {
    static let shared: BusinessDataService = .init()
    private init() {}
    
    let batchSize: Int = 50
    
    func fetchData<T: Decodable>(nearby address: String, businessType: String,
                                 onComplete: @escaping (Result<T, BusinessDataService.NetworkError>) -> Void) -> Void {
        let endpoint = "\(ApiConstants.Endpoint.baseSearch)?\(ApiConstants.Endpoint.addAddress(address.urlEncoded))&\(ApiConstants.Endpoint.addBusinessType(businessType.urlEncoded))&\(ApiConstants.Endpoint.defaultRadiusAndBatchLimit)"
        
        guard let url = URL(string: endpoint) else {
            onComplete(.failure(.invalidInputs))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let headers = [
            "accept": "application/json",
            "Authorization": ApiConstants.authString
        ]
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                onComplete(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                onComplete(.failure(.invalidResponse))
                return
            }
            
            guard let data else {
                onComplete(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            guard let decoded = try? decoder.decode(T.self, from: data) else {
                onComplete(.failure(.invalidData))
                return
            }
            
            onComplete(.success(decoded))
        }
        .resume()
    }
    
    
    func fetchData<T: Decodable>(with id: String, onComplete: @escaping (Result<T, BusinessDataService.NetworkError>) -> Void) -> Void {
        let endpoint = "\(ApiConstants.Endpoint.baseGetById)\(id)"
        
        guard let url = URL(string: endpoint) else {
            onComplete(.failure(.invalidInputs))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let headers = [
            "accept": "application/json",
            "Authorization": ApiConstants.authString
        ]
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                onComplete(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                onComplete(.failure(.invalidResponse))
                return
            }
            
            guard let data else {
                onComplete(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            guard let decoded = try? decoder.decode(T.self, from: data) else {
                onComplete(.failure(.invalidData))
                return
            }
            
            onComplete(.success(decoded))
        }
        .resume()
    }
    
    
    @available(iOS 15.0, *)
    func fetchData<T: Decodable>(with id: String) async throws -> T {
        let endpoint = "\(ApiConstants.Endpoint.baseGetById)\(id)"
        
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidInputs }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let headers = [
            "accept": "application/json",
            "Authorization": ApiConstants.authString
        ]
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch { throw NetworkError.invalidData }
    }
    
    @available(iOS 15.0, *)
    func fetchData<T: Decodable>(nearby address: String, businessType: String) async throws -> T {
        let endpoint = "\(ApiConstants.Endpoint.baseSearch)?\(ApiConstants.Endpoint.addAddress(address.urlEncoded))&\(ApiConstants.Endpoint.addBusinessType(businessType.urlEncoded))&\(ApiConstants.Endpoint.defaultRadiusAndBatchLimit)"
        
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidInputs }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let headers = [
            "accept": "application/json",
            "Authorization": ApiConstants.authString
        ]
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch { throw NetworkError.invalidData }
    }
}

extension BusinessDataService {
    internal enum NetworkError: String, Error {
        case invalidInputs = "Your request contains invalid inputs. Please try again."
        case unableToComplete = "Unable to complete your request. Please check your internet connection and try again."
        case invalidResponse = "The server sent an invalid response. Please try again later."
        case invalidData = "Invalid data received from server. Please try again later."
    }
}
