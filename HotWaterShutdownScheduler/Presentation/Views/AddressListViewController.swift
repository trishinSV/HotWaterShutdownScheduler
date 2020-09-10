//
//  ViewController.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 08.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import UIKit

protocol AddressListViewProtocol: AnyObject {

    // MARK: - Properties

    var presenter: AddressListPresenterProtocol! { get set }

    // MARK: - Methods

    func update()
    func show(error: String)
}

class AddressListViewController: UIViewController {

    // MARK: - Properties

    lazy var presenter: AddressListPresenterProtocol! = AddressListPresenter()

    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    private var refreshControl: UIRefreshControl = UIRefreshControl()

    // MARK: - IBOutlets

    @IBOutlet private var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        presenter.view = self
        prepareView()
    }

    // MARK: - Methods

    private func prepareView() {
        self.navigationItem.title = "Schedule".localized
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()

        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)

        tableView.register(UINib(nibName: String(describing: AddressListTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: AddressListTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc private func refresh() {
        presenter.update()
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
        UITableView.automaticDimension
    }
}

extension AddressListViewController: AddressListViewProtocol {

    func show(error: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error".localized, message: error, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK".localized, style: .cancel)

            let retryAction = UIAlertAction(title: "Retry".localized, style: .default) { (_: UIAlertAction) in
                self.activityIndicator.startAnimating()
                self.presenter.update()
            }

            alertController.addAction(okAction)
            alertController.addAction(retryAction)
            self.present(alertController, animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }

    func update() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
}
