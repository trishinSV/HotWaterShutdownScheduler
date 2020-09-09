//
//  ViewController.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 08.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import UIKit

protocol AddressListViewProtocol: AnyObject {

    var presenter: AddressListPresenterProtocol! { get set }
    func update()
}

class AddressListViewController: UIViewController {

    lazy var presenter: AddressListPresenterProtocol! = AddressListPresenter()

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        presenter.view = self
        tableView.register(UINib(nibName: String(describing: AddressListTableViewCell.self), bundle: nil),
                                         forCellReuseIdentifier: String(describing: AddressListTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension AddressListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddressListTableViewCell.self), for: indexPath) as? AddressListTableViewCell else {
            fatalError("TableViewCell по индексу \(indexPath) не имеет тип \(String(describing: AddressListTableViewCell.self))")
        }

        guard let cellPresenter = presenter.addressListCellPresenter(at: indexPath) else {
            fatalError("Не удалось получить presenter для \(String(describing: AddressListTableViewCell.self)) по индексу \(indexPath)")
        }

        cell.presenter = cellPresenter
        cell.presenter.view = cell

        return cell
    }
}

extension AddressListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension AddressListViewController: AddressListViewProtocol {
    func update() {
        tableView.reloadData()
    }
}
