//
//  MyTimers+CoreDataProperties.swift
//  TimersAndLocation
//
//  Created by Charles Konkol on 2015-11-09.
//  Copyright © 2015 Chuck Konkol. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MyTimers {

    @NSManaged var timerdate: NSDate?
    @NSManaged var timelong: String?
    @NSManaged var timermsg: String?
    @NSManaged var timername: String?
    @NSManaged var timersound: String?
    @NSManaged var timertime: String?
    @NSManaged var timelat: String?
    @NSManaged var bylocation: NSNumber?

}
