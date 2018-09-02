//
//  Fotos+CoreDataClass.swift
//  ObjJKH
//
//  Created by Роман Тузин on 31.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//
//

import Foundation
import CoreData


public class Fotos: NSManagedObject {
    
    convenience init() {
        
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Fotos"), insertInto: CoreDataManager.instance.managedObjectContext)
        
    }
    
}
