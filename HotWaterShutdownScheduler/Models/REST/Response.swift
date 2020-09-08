//
//  Response.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 08.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import Foundation

// MARK: - Response

struct Response: Codable {
    let status: String
    let responseData: ResponseData
    let expectedResponseDate: String
}

// MARK: - Data

struct ResponseData: Codable {
    let classifiers: [Classifier]
}

// MARK: - Classifier

struct Classifier: Codable {
    let classifierID: Int
    let classifierName, file, version: String

    enum CodingKeys: String, CodingKey {
        case classifierID = "classifierId"
        case classifierName, file, version
    }
}
