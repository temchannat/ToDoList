//
//  ToDo+CoreDataProperties.swift
//  ToDoListCoreData
//
//  Created by Channat Tem on 9/26/16.
//  Copyright © 2016 Channat Tem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ToDo {

    @NSManaged var content: String?
    @NSManaged var finished: NSNumber?
    
    

}
