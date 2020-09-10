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
    func show(error: String)
}

class AddressListViewController: UIViewController {

    lazy var presenter: AddressListPresenterProtocol! = AddressListPresenter()

    @IBOutlet private var tableView: UITableView!
    private var activityIndicator: UIActivityIndicatorView!
    private var refreshControl: UIRefreshControl!
//    private var alertController: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        presenter.view = self
        self.navigationItem.title = "График отключения горячей воды"


        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()



        self.refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
//
//        self.alertController = UIAlertController(title: "Alert", message: "This is an alert.", preferredStyle: .alert)
//
//        let action1 = UIAlertAction(title: "Default", style: .default) { (action:UIAlertAction) in
//            print("You've pressed default");
//        }
//
//        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
//            print("You've pressed cancel");
//        }
//
//        alertController.addAction(action1)
//        alertController.addAction(action2)

        tableView.register(UINib(nibName: String(describing: AddressListTableViewCell.self), bundle: nil),
                                         forCellReuseIdentifier: String(describing: AddressListTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc func refresh() {
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
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)

        let action1 = UIAlertAction(title: "Cancel", style: .cancel)

        let action2 = UIAlertAction(title: "Retry", style: .default) { (action:UIAlertAction) in
            self.activityIndicator.startAnimating()
            self.presenter.update()
        }

        alertController.addAction(action1)
        alertController.addAction(action2)
        DispatchQueue.main.async {
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
