//
//  AttendanceRecord+CoreDataProperties.swift
//  GEmock
//
//  Created by 陈昊 on 4/19/16.
//  Copyright © 2016 Yushi xiao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AttendanceRecord {

    @NSManaged var employee_id: String?
    @NSManaged var first_name: String?
    @NSManaged var last_name: String?
    @NSManaged var attended: Event?

}
