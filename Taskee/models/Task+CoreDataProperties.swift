//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Nicholas Kearns on 7/7/20.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var status: Bool
    @NSManaged public var project: Project?

}
