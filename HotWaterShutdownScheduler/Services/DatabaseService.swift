//
//  DatabaseService.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 09.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import Foundation
import CoreData

protocol DatabaseServiceProtocol: AnyObject {
    func fetch(address: Address) -> DBAddress?
    func fetchAll() -> AddressList
    func save(array: AddressList)
    func deleteAll()
}
final class DatabaseService: DatabaseServiceProtocol {

    // MARK: - Private

    private init() {}

    private var isLoading: Bool = false

    private func map(dbAddress: DBAddress) -> Address {
        Address(city: dbAddress.city ?? "",
                houseAddress: dbAddress.houseAddress ?? "",
                houseNumber: dbAddress.houseNumber ?? "",
                housing: dbAddress.housing ?? "",
                liter: dbAddress.liter ?? "",
                period: dbAddress.period ?? "")
    }

    private func map(address: Address, context: NSManagedObjectContext) -> NSManagedObject? {
//        if let ent = self.fetch(address: address) { return ent }
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

    // MARK: - Public

    static let shared: DatabaseServiceProtocol = DatabaseService()

    func fetch(address: Address) -> DBAddress? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DBAddress.self))
        request.predicate = NSPredicate(format: "houseAddress == %@ AND houseNumber == %@ AND housing == %@ AND liter == %@",
                                        address.houseAddress,
                                        address.houseNumber,
                                        address.housing,
                                        address.liter)
        request.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true)]

        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        do {
            try frc.performFetch()
            if let result = frc.fetchedObjects?.first as? DBAddress {
                return result
            }
        } catch {
            print(error)
        }
        return nil
    }

    func fetchAll() -> AddressList {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DBAddress.self))
        request.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        do {
            try frc.performFetch()
            if let result = frc.fetchedObjects as? [DBAddress] {
                return result.map { self.map(dbAddress: $0)}
            }
        } catch {
            print(error)
        }
        return []
    }

    func save(array: AddressList) {
        guard !isLoading else { return }
        self.isLoading.toggle()
        self.deleteAll()
        let context = CoreDataStack.sharedInstance.updateContext
        _ = array.map { self.map(address: $0, context: context) }
        do {
            try context.save()
        } catch let error {
            print(error)
        }
        self.isLoading.toggle()
    }

    func deleteAll() {
        do {
            let context = CoreDataStack.sharedInstance.updateContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DBAddress.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map {$0.map {context.delete($0)}}
//                CoreDataStack.sharedInstance.updateContext
            } catch let error {
                print(error)
            }
        }
    }

}

//extension DatabaseService: NSFetchedResultsControllerDelegate {
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
