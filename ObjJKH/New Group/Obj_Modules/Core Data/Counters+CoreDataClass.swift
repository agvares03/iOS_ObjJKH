//
//  Counters+CoreDataClass.swift
//  
//
//  Created by Sergey Ivanov on 07/10/2019.
//
//

import Foundation
import CoreData

@objc(Counters)
public class Counters: NSManagedObject {

    convenience init() {
        
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Counters"), insertInto: CoreDataManager.instance.managedObjectContext)
        
    }
}
