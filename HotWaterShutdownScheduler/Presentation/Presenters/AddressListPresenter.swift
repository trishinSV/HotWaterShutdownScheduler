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

    var view: AddressListViewProtocol! { get set }

    var numberOfRows: Int { get }

    func viewDidLoad()
    func addressListCellPresenter(at indexPath: IndexPath) -> AddressListCellPresenterProtocol?

}

class AddressListPresenter: AddressListPresenterProtocol {

    var view: AddressListViewProtocol!

    var numberOfRows: Int { addressList.count }

    private var addressList: AddressList = []

    func viewDidLoad() {
        self.addressList = DatabaseService.shared.fetchAll()

        NetworkService.shared.getDataWith { result in
            switch result {
                case let .success(file):
                    FileService.shared.decode(file: file) { result in
                        switch result {
                            case let .success(list):
                                self.addressList = list
                                self.view.update()
                                DispatchQueue.global(qos: .background).async {
                                    DatabaseService.shared.save(array: list)

                                }
                            case .failure: print("f")
                        }
                }
                case .failure: print("f")
            }
        }
    }

    func addressListCellPresenter(at indexPath: IndexPath) -> AddressListCellPresenterProtocol? {
        guard addressList.indices ~= indexPath.row else { return nil }
        let address = addressList[indexPath.row]
        return AddressListCellPresenter(address: address)
    }
}

//extension AddressListPresenter: NSFetchedResultsControllerDelegate {
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        //
//        //        switch type {
//        //            case .insert:
//        //                self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        //            case .delete:
//        //                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
//        //            default:
//        //                break
//        //        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        //        self.tableView.endUpdates()
//    }
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        //        tableView.beginUpdates()
//    }
//}
