//
//  CoreDataStack.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 08.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import CoreData
import Foundation

protocol CoreDataStackProtocol: AnyObject {

    // MARK: - Properties

    var persistentContainer: NSPersistentContainer { get }
    var viewContext: NSManagedObjectContext { get }
    var updateContext: NSManagedObjectContext { get }

    // MARK: - Methods

    func saveUpdateContext()
}

class CoreDataStack: CoreDataStackProtocol {

    // MARK: - Private

    private init() {}

    // MARK: - Public

    static let shared: CoreDataStackProtocol = CoreDataStack()

    // MARK: - Core Data stack

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HotWaterShutdownScheduler")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving support

    func saveUpdateContext() {
        do {
            try updateContext.save()
            CoreDataStack.shared.viewContext.performAndWait {
                do {
                    try CoreDataStack.shared.viewContext.save()
                } catch {
                    let error = error as Error
                    print(error)
                }
            }
        } catch {
            let error = error as Error
            print(error)
        }
    }

    // MARK: - Core Data Contexts

    lazy var viewContext: NSManagedObjectContext = {
        self.persistentContainer.viewContext
    }()

    lazy var updateContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.persistentContainer.viewContext
        return context
    }()
}
