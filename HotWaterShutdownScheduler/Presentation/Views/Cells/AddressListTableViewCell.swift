//
//  AddressListTableViewCell.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 09.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import UIKit

protocol AddressListCellViewProtocol: AnyObject {

    var presenter: AddressListCellPresenterProtocol! { get set }
}

class AddressListTableViewCell: UITableViewCell {

    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var streetLabel: UILabel!
    @IBOutlet private var houseLabel: UILabel!
    @IBOutlet private var periodLabel: UILabel!

    var presenter: AddressListCellPresenterProtocol! {
        didSet { bindPresenter() }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bindPresenter() {
        cityLabel.text = presenter.cityTitle
        streetLabel.text = presenter.streetTitle
        houseLabel.text = presenter.houseTitle
        periodLabel.text = presenter.periodTitle
    }
}

extension AddressListTableViewCell: AddressListCellViewProtocol {}
