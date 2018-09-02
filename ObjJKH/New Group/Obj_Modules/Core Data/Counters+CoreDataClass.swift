//
//  Counters+CoreDataClass.swift
//  ObjJKH
//
//  Created by Роман Тузин on 29.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//
//

import Foundation
import CoreData

public class Counters: NSManagedObject {
    
    convenience init() {
        
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Counters"), insertInto: CoreDataManager.instance.managedObjectContext)
        
    }
    
}
