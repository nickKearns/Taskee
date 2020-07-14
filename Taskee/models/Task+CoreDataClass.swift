//
//  Task+CoreDataClass.swift
//  
//
//  Created by Nicholas Kearns on 7/7/20.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        
        dueDate = Date()
        status = false
        title = ""
        
    }
    
    
    
}
