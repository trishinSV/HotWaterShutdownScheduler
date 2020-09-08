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
    case networkError(String)
    case decodingError
    case diskError
}
