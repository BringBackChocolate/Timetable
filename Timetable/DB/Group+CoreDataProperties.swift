//
//  Group+CoreDataProperties.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 04.03.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Group {

    @NSManaged var id: NSNumber?
    @NSManaged var level: NSNumber?
    @NSManaged var name: String?
    @NSManaged var spec: String?
    @NSManaged var type: String?
    @NSManaged var bookmark: Bookmark?
    @NSManaged var faculty: Faculty?
    @NSManaged var weeks: Week?

}
