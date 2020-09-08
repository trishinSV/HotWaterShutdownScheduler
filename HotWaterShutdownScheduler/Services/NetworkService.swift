//
//  NetworkService.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 08.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getDataWith(completion: @escaping (Result<String, APIError>) -> Void)
}

class NetworkService: NetworkServiceProtocol {

    static let shared: NetworkServiceProtocol = NetworkService()

    private lazy var endpoint: String = {
        "https://api.gu.spb.ru/UniversalMobileService/classifiers/downloadClassifiers?classifiersId=4"
    }()

    func getDataWith(completion: @escaping (Result<String, APIError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            return completion(.failure(.badURL)) }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                return completion(.failure(.taskError(error?.localizedDescription ?? "")))
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                guard let file = response.responseData.classifiers.first?.file else {
                    return completion(.failure(.taskError(error?.localizedDescription ?? "")))
                }
                DispatchQueue.main.async {
                    completion(.success(file))
                }
            } catch let error {
                return completion(.failure(.taskError(error.localizedDescription)))
            }
        }.resume()
    }
}

enum APIError: Error {
    case badURL
    case taskError(String)
}
