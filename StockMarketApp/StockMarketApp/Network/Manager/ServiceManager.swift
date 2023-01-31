//
//  Service.swift
//  StockMarketApp
//
//  Created by Burak Erden on 30.01.2023.
//

import Alamofire

final class ServiceManager {
    public static let shared: ServiceManager = ServiceManager()
}

extension ServiceManager {
    func fetch<T>(path: String, onSuccess: @escaping (T) -> Void, onError: @escaping (AFError) -> Void) where T: Codable {
        AF.request(path, encoding: JSONEncoding.default).validate().responseDecodable(of: T.self) { (response) in
            guard let model = response.value else {
                print(response)
                return
                
            }
            onSuccess(model)
        }
    }
}
