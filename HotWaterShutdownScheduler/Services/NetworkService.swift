//
//  NetworkService.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 08.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func getDataWith(completion: @escaping (Result<String, HWSSError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    // MARK: - Private

    private init() {}

    private lazy var endpoint: String = {
        "https://api.gu.spb.ru/UniversalMobileService/classifiers/downloadClassifiers?classifiersId=4"
    }()

    // MARK: - Public

    static let shared: NetworkServiceProtocol = NetworkService()

    func getDataWith(completion: @escaping (Result<String, HWSSError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            return completion(.failure(.badURL)) }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                return completion(.failure(.networkError(error?.localizedDescription ?? "")))
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                guard let file = response.responseData.classifiers.first?.file else {
                    return completion(.failure(.networkError(error?.localizedDescription ?? "")))
                }
                DispatchQueue.main.async {
                    completion(.success(file))
                }
            } catch let error {
                return completion(.failure(.networkError(error.localizedDescription)))
            }
        }.resume()
    }
}
