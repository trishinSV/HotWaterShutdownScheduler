//
//  DatabaseService.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 09.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import CoreData
import Foundation

protocol DatabaseServiceProtocol: AnyObject {

    // MARK: - Methods

    func fetchAll(completion: @escaping (AddressList) -> Void)
    func save(array: AddressList)
    func deleteAll()
}
final class DatabaseService: DatabaseServiceProtocol {

    // MARK: - Init

    private init() {}

    // MARK: - Public

    static let shared: DatabaseServiceProtocol = DatabaseService()

    func fetchAll(completion: @escaping (AddressList) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DBAddress.self))
            request.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true)]
            let frc = NSFetchedResultsController(fetchRequest: request,
                                                 managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext,
                                                 sectionNameKeyPath: nil,
                                                 cacheName: nil)
            do {
                try frc.performFetch()
                if let result = frc.fetchedObjects as? [DBAddress] {
                    completion(result.map { self.map(dbAddress: $0) })
                }
            } catch {
                print(error)
            }
        }
    }

    func save(array: AddressList) {
        self.deleteAll()
        let context = CoreDataStack.shared.updateContext
        context.perform {
            _ = array.map { self.map(address: $0, context: context) }
            CoreDataStack.shared.saveUpdateContext()
        }
    }

    func deleteAll() {
        do {
            let context = CoreDataStack.shared.updateContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DBAddress.self))
            context.perform {
                do {
                    let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                    _ = objects.map { $0.map { context.delete($0) } }
                    CoreDataStack.shared.saveUpdateContext()
                } catch {
                    let error = error as Error
                    print(error)
                }
            }
        }
    }

    // MARK: - Private

    private func map(dbAddress: DBAddress) -> Address {
        Address(city: dbAddress.city ?? "",
                houseAddress: dbAddress.houseAddress ?? "",
                houseNumber: dbAddress.houseNumber ?? "",
                housing: dbAddress.housing ?? "",
                liter: dbAddress.liter ?? "",
                period: dbAddress.period ?? "")
    }

    private func map(address: Address, context: NSManagedObjectContext) -> NSManagedObject? {
        if let dbAddress = NSEntityDescription.insertNewObject(forEntityName: "DBAddress", into: context) as? DBAddress {
            dbAddress.city = address.city
            dbAddress.houseAddress = address.houseAddress
            dbAddress.houseNumber = address.houseNumber
            dbAddress.housing = address.housing
            dbAddress.liter = address.liter
            dbAddress.period = address.period
            return dbAddress
        }
        return nil
    }
}
