//
//  PaymentApp+CoreDataProperties.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 08/05/2019.
//  Copyright © 2019 The Best. All rights reserved.
//
//

import Foundation
import CoreData


extension PaymentApp {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaymentApp> {
        return NSFetchRequest<PaymentApp>(entityName: "PaymentApp")
    }

    @NSManaged public var id: Int64
    @NSManaged public var id_pay: Int64
    @NSManaged public var date: String?
    @NSManaged public var ident: String?
    @NSManaged public var status: String?
    @NSManaged public var desc: String?
    @NSManaged public var sum: String?

}
