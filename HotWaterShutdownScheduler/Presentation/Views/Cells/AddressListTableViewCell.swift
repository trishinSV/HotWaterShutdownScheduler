//
//  AddressListTableViewCell.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 09.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import UIKit

protocol AddressListCellViewProtocol: AnyObject {

    // MARK: - Properties

    var presenter: AddressListCellPresenterProtocol! { get set }
}

class AddressListTableViewCell: UITableViewCell {

    // MARK: - Private

    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var streetLabel: UILabel!
    @IBOutlet private var houseLabel: UILabel!
    @IBOutlet private var periodLabel: UILabel!

    // MARK: - Public

    var presenter: AddressListCellPresenterProtocol! {
        didSet { bindPresenter() }
    }

    func bindPresenter() {
        cityLabel.text = presenter.cityTitle
        streetLabel.text = presenter.streetTitle
        houseLabel.text = presenter.houseTitle
        periodLabel.text = presenter.periodTitle
    }
}

extension AddressListTableViewCell: AddressListCellViewProtocol {}
