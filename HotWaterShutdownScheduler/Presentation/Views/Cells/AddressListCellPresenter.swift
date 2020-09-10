//
//  AddressListCellPresenter.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 09.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import UIKit

protocol AddressListCellPresenterProtocol: AnyObject {

    // MARK: - Properties

    var view: AddressListCellViewProtocol! { get set }

    var cityTitle: String { get }
    var streetTitle: String { get }
    var houseTitle: String { get }
    var periodTitle: String { get }
}

class AddressListCellPresenter: AddressListCellPresenterProtocol {

    // MARK: - Public

    var view: AddressListCellViewProtocol!

    var cityTitle: String
    var streetTitle: String
    var houseTitle: String
    var periodTitle: String

    init(address: Address) {
        cityTitle = address.city.trimmingCharacters(in: .whitespaces).count == 0 ? "" : address.city
        streetTitle = address.houseAddress.trimmingCharacters(in: .whitespaces).count == 0 ? "" : address.houseAddress

        let house = address.houseNumber.trimmingCharacters(in: .whitespaces).count == 0 ? "" : "дом " + address.houseNumber
        let housing = address.housing.trimmingCharacters(in: .whitespaces).count == 0 ? "" : " корпус " + address.housing
        let liter = address.liter.trimmingCharacters(in: .whitespaces).count == 0 ? "" : " литера " + address.liter

        houseTitle = house + housing + liter

        let dateList: [String] = address.period.split(separator: "-").map { String($0) }
        var formattedDateList: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "ru_RU")

        dateList.forEach {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            if let date = dateFormatter.date(from: $0) {
                dateFormatter.dateFormat = "dd MMMM yyyy"
                formattedDateList.append(dateFormatter.string(from: date))
            }
        }
        periodTitle = formattedDateList.joined(separator: " - ")
    }
}
