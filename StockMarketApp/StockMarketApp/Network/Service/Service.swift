//
//  Service.swift
//  StockMarketApp
//
//  Created by Burak Erden on 30.01.2023.
//

import Alamofire

protocol ServiceProtocol {
    func getCurrencyData(onSuccess: @escaping (CurrencyApi?) -> Void, onError: @escaping (AFError) -> Void)
}

final class Service: ServiceProtocol {
    func getCurrencyData(onSuccess: @escaping (CurrencyApi?) -> Void, onError: @escaping (Alamofire.AFError) -> Void) {
        ServiceManager.shared.fetch(path: "https://psp-merchantpanel-service-sandbox.ozanodeme.com.tr/api/v1/dummy/coins") { (response: CurrencyApi) in
            onSuccess(response)
        } onError: { (error) in
            onError(error)
        }
    }
}
