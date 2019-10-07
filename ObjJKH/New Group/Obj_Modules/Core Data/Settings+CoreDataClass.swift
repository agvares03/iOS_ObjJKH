//
//  Settings+CoreDataClass.swift
//  ObjJKH
//
//  Created by Роман Тузин on 23.10.2018.
//  Copyright © 2018 The Best. All rights reserved.
//
//

import Foundation
import CoreData
@objc(Settings)
public class Settings: NSManagedObject {
    
    convenience init() {
        
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Settings"), insertInto: CoreDataManager.instance.managedObjectContext)
        
    }

}
