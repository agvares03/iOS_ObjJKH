//
//  Applications+CoreDataClass.swift
//  ObjJKH
//
//  Created by Роман Тузин on 12.10.2018.
//  Copyright © 2018 The Best. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Applications)
public class Applications: NSManagedObject {
    
    convenience init() {
        
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Applications"), insertInto: CoreDataManager.instance.managedObjectContext)
        
    }

}
