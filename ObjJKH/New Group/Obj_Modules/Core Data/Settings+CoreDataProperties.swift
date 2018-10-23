//
//  Settings+CoreDataProperties.swift
//  ObjJKH
//
//  Created by Роман Тузин on 23.10.2018.
//  Copyright © 2018 The Best. All rights reserved.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var diff: String?

}
