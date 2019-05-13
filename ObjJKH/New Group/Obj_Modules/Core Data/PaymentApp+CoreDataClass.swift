//
//  PaymentApp+CoreDataClass.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 08/05/2019.
//  Copyright © 2019 The Best. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PaymentApp)
public class PaymentApp: NSManagedObject {

    convenience init() {
        
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "PaymentApp"), insertInto: CoreDataManager.instance.managedObjectContext)
        
    }
}
