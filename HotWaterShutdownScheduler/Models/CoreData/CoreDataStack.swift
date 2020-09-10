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

    func saveContext ()
}

class CoreDataStack: CoreDataStackProtocol {

    // MARK: - Private

    private init() {}

    // MARK: - Public

    static let shared: CoreDataStackProtocol = CoreDataStack()

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HotWaterShutdownScheduler")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Core Data Contexts

    lazy var viewContext: NSManagedObjectContext = {
        self.persistentContainer.viewContext
    }()

    lazy var updateContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.viewContext
        return context
    }()
}
