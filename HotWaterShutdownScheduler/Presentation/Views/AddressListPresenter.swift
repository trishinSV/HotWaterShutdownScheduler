//
//  AddressListPresenter.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 09.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import Foundation

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

    // MARK: - Properties

    private var addressList: AddressList = []
    private var cellPresenter: AddressListCellPresenter = AddressListCellPresenter()

    var view: AddressListViewProtocol!
    var numberOfRows: Int { addressList.count }

    // MARK: - Methods

    func viewDidLoad() {
        update()
    }

    func update() {
        DatabaseService.shared.fetchAll { list in
            self.addressList = list.sorted { $0.city < $1.city }
            self.view.update()
        }
        DispatchQueue.global(qos: .userInteractive).async {
            NetworkService.shared.getDataWith { result in
                switch result {
                    case let .success(file):
                        DispatchQueue.global(qos: .userInteractive).async {
                            FileService.shared.decode(file: file) { result in
                                switch result {
                                    case let .success(list):
                                        self.addressList = list.sorted { $0.city < $1.city }
                                        self.view.update()
                                            DatabaseService.shared.save(array: list)
                                    case let .failure(error):
                                        self.view.show(error: error.localizedDescription)
                                }
                            }
                        }
                    case let .failure(error):
                        self.view.show(error: error.localizedDescription)
                }
            }
        }
    }

    func addressListCellPresenter(at indexPath: IndexPath) -> AddressListCellPresenterProtocol? {
        guard addressList.indices ~= indexPath.row else { return nil }
        let address = addressList[indexPath.row]
        self.cellPresenter.configure(with: address)
        return self.cellPresenter
    }
}
