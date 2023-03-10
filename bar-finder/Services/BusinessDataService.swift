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
        let endpoint = "\(YelpAPIConstants.YelpAPIEndpoint.searchEndpointBaseURL)?\(YelpAPIConstants.YelpAPIEndpoint.locationSearchQueryParameter(address.urlEncoded))&\(YelpAPIConstants.YelpAPIEndpoint.businessTypeSearchQueryParameter(businessType.urlEncoded))&\(YelpAPIConstants.YelpAPIEndpoint.defaultSearchRadiusAndBatchLimitQueryParameter)"
        
        guard let url = URL(string: endpoint) else {
            onComplete(.failure(.invalidInputs))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let headers = [
            "accept": "application/json",
            "Authorization": YelpAPIConstants.yelpAPIAuthorizationString
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
        let endpoint = "\(YelpAPIConstants.YelpAPIEndpoint.getBusinessByIDEndpointBaseURL)\(id)"
        
        guard let url = URL(string: endpoint) else {
            onComplete(.failure(.invalidInputs))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let headers = [
            "accept": "application/json",
            "Authorization": YelpAPIConstants.yelpAPIAuthorizationString
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
        let endpoint = "\(YelpAPIConstants.YelpAPIEndpoint.getBusinessByIDEndpointBaseURL)\(id)"
        
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidInputs }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let headers = [
            "accept": "application/json",
            "Authorization": YelpAPIConstants.yelpAPIAuthorizationString
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
        let endpoint = "\(YelpAPIConstants.YelpAPIEndpoint.searchEndpointBaseURL)?\(YelpAPIConstants.YelpAPIEndpoint.locationSearchQueryParameter(address.urlEncoded))&\(YelpAPIConstants.YelpAPIEndpoint.businessTypeSearchQueryParameter(businessType.urlEncoded))&\(YelpAPIConstants.YelpAPIEndpoint.defaultSearchRadiusAndBatchLimitQueryParameter)"
        
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidInputs }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let headers = [
            "accept": "application/json",
            "Authorization": YelpAPIConstants.yelpAPIAuthorizationString
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
        case invalidInputs = "Sua solicitação contém entradas inválidas. Por favor, tente novamente."
        case unableToComplete = "Não é possível completar sua solicitação. Por favor, verifique sua conexão com a internet e tente novamente."
        case invalidResponse = "O servidor enviou uma resposta inválida. Por favor, tente novamente mais tarde."
        case invalidData = "Dados inválidos recebidos do servidor. Por favor, tente novamente mais tarde."
    }
}
