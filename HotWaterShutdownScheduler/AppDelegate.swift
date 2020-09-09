//
//  AppDelegate.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 08.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import UIKit
import CoreData
import Zip

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkService.shared.getDataWith { result in
            switch result {
                case let .success(file):
                FileService.shared.decode(file: file) { result in
                    switch result {
                        case let .success(list):
                            DatabaseService.shared.save(array: list)
                        case .failure: print("f")
                    }
                }
                case .failure: print("f")
            }
        }
        let res = DatabaseService.shared.fetchAll()
        return true
    }
}
