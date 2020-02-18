//
//  Comments+CoreDataProperties.swift
//  ObjJKH
//
//  Created by Роман Тузин on 31.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//
//

import Foundation
import CoreData


extension Comments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comments> {
        return NSFetchRequest<Comments>(entityName: "Comments")
    }

    @NSManaged public var text: String?
    @NSManaged public var id_author: String?
    @NSManaged public var id_app: Int64
    @NSManaged public var id_account: String?
    @NSManaged public var id: Int64
    @NSManaged public var dateK: Date?
    @NSManaged public var date: String?
    @NSManaged public var author: String?
    @NSManaged public var is_hidden: Bool
    @NSManaged public var serverStatus: String?
    @NSManaged public var id_file: Int64

}
