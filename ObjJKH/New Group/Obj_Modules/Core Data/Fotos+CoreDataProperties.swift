//
//  Fotos+CoreDataProperties.swift
//  ObjJKH
//
//  Created by Роман Тузин on 31.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//
//

import Foundation
import CoreData


extension Fotos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fotos> {
        return NSFetchRequest<Fotos>(entityName: "Fotos")
    }

    @NSManaged public var number: String?
    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var foto_small: NSData?
    @NSManaged public var foto_path: String?
    @NSManaged public var date: String?

}
