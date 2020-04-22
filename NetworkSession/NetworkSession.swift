//
//  NetworkSession.swift
//  NetworkSession
//
//  Created by Daniel Rocha on 26/02/20.
//  Copyright © 2020 Daniel Rocha. All rights reserved.
//

import Foundation

public protocol NetworkProtocol {
    typealias ResultCompletion<R> = (Result<R?, NetworkError>) -> Void
    func request<R: Decodable>(request: NetworkRequestProtocol, result: @escaping ResultCompletion<R>)
}

public protocol NetworkRequestProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any] { get }
}

public class NetworkSession: NetworkProtocol {
    // MARK: - Private Properties
    private let session = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    public static let shared = NetworkSession()
    
    private init() {}
    
    // MARK: - Internal Methods
    public func request<R: Decodable>(request: NetworkRequestProtocol, result: @escaping ResultCompletion<R>) {
        dataTask?.cancel()
        
        do {
            let url = try createURL(request)

            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.allHTTPHeaderFields = request.headers
            urlRequest.httpBody = try createBody(request)
             
            #if DEBUG
            print("🚀 UrlRequest: \(urlRequest)")
            #endif
            
            dataTask = session.dataTask(with: urlRequest, completionHandler: { [weak self] (data, response, error) in
                defer { self?.dataTask = nil }
                 
                guard let http = response as? HTTPURLResponse else {
                    printFailure("Problemas de conexão")
                    result(.failure(NetworkError.connectionFailure))
                    return
                }

                guard let status = HTTPStatusCode(rawValue: http.statusCode), let data = data else {
                    printFailure("Falha ao converter status code ou data")
                    result(.failure(NetworkError.connectionFailure))
                    return
                }

                printStatus(http.statusCode, data: data)
                switch status {
                case .ok:
                    guard let model = try? JSONDecoder().decode(R.self, from: data) as R else {
                        result(.success(nil))
                        return
                    }

                    result(.success(model))
                default:
                     if let error = error {
                         printFailure("Erro de requisição \(error.localizedDescription)")
                         result(.failure(NetworkError.requestError(error)))
                         return
                     }
                     printFailure("Erro de requisição desconhecido")
                     result(.failure(NetworkError.unknown))
                }
            })
            
            dataTask?.resume()
        } catch let error {
            printFailure("Lançamento de falha \(error.localizedDescription)")
            guard let error = error as? NetworkError else {
                result(.failure(.unknown))
                return
            }
            result(.failure(error))
        }
    }
    
    // MARK: - Private Methods
    private func createURL(_ request: NetworkRequestProtocol) throws -> URL {
        let requestUrl = "\(request.baseURL)\(request.path)"
        var component = URLComponents(string: requestUrl)
        
        if request.method == .get && !request.parameters.isEmpty {
            component?.queryItems = request.parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let url = component?.url else {
            printFailure("Problemas ao converter url")
            throw NetworkError.malformedRequest
        }
        
        return url
    }
    
    private func createBody(_ request: NetworkRequestProtocol) throws -> Data? {
        guard  request.method != .get else { return nil }
        return try JSONSerialization.data(withJSONObject: request.parameters)
    }
}

fileprivate func printFailure(_ message: String) {
    #if DEBUG
    print("❌ \(message)")
    #endif
}

fileprivate func printStatus(_ status: Int, data: Data) {
    #if DEBUG
    print("✅ Status: \(status)")
    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
        print("Json: \(json)")
    }
    #endif
}


