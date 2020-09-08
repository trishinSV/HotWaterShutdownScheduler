//
//  Address.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 08.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import Foundation

typealias AddressList = [Address]

// MARK: - Address

struct Address: Codable {
    let city, houseAddress, houseNumber: String
    let housing, liter, period: String

    enum CodingKeys: String, CodingKey {
        case city = "Населенный пункт"
        case houseAddress = "Адрес жилого здания"
        case houseNumber = "№ дома"
        case housing = "корпус"
        case liter = "литер"
        case period = "Период отключения ГВС"
    }
}
