//
//  DBAddress.swift
//  HotWaterShutdownScheduler
//
//  Created by Сергей Тришин on 09.09.2020.
//  Copyright © 2020 Сергей Тришин. All rights reserved.
//

import CoreData

public class DBAddress: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBAddress> {
        NSFetchRequest<DBAddress>(entityName: "DBAddress")
    }

    @NSManaged public var city: String?
    @NSManaged public var houseAddress: String?
    @NSManaged public var houseNumber: String?
    @NSManaged public var housing: String?
    @NSManaged public var liter: String?
    @NSManaged public var period: String?
}
