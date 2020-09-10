//
//  AddressListPresenter.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 09.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import UIKit
import CoreData

protocol AddressListPresenterProtocol: AnyObject {

    // MARK: - Properties

    var view: AddressListViewProtocol! { get set }
    var numberOfRows: Int { get }

    // MARK: - Methods

    func viewDidLoad()
    func update()
    func addressListCellPresenter(at indexPath: IndexPath) -> AddressListCellPresenterProtocol?
}

class AddressListPresenter: AddressListPresenterProtocol {

    // MARK: - Private

    private var addressList: AddressList = []

    // MARK: - Public

    var view: AddressListViewProtocol!

    var numberOfRows: Int { addressList.count }

    func viewDidLoad() {
        self.addressList = DatabaseService.shared.fetchAll().sorted { $0.city < $1.city }
        self.update()
    }

    func update() {
        NetworkService.shared.getDataWith { result in
            switch result {
                case let .success(file):
                    FileService.shared.decode(file: file) { result in
                        switch result {
                            case let .success(list):
                                self.addressList = list.sorted { $0.city < $1.city }
                                self.view.update()
                                DispatchQueue.global(qos: .background).async {
                                    DatabaseService.shared.save(array: list)
                            }
                            case let .failure(error):
                                self.view.show(error: error.localizedDescription)
                        }
                }
                case let .failure(error):
                    self.view.show(error: error.localizedDescription)
            }
        }
    }

    func addressListCellPresenter(at indexPath: IndexPath) -> AddressListCellPresenterProtocol? {
        guard addressList.indices ~= indexPath.row else { return nil }
        let address = addressList[indexPath.row]
        return AddressListCellPresenter(address: address)
    }
}
