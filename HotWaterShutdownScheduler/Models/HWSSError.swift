//
//  HWSSError.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 08.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import UIKit

enum HWSSError: Error {
    case badURL
    case networkError
    case decodingError
    case diskError
}

extension HWSSError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .badURL:
                return "Bad URL"
            case .networkError:
                return "Network error"
            case .decodingError:
                return "Decoding error"
            case .diskError:
                return "File writing error"
        }
    }
}
