//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by Julie Collazos on 01/06/2023.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var isDone: Bool
    @NSManaged public var notifId: String?
    @NSManaged public var order: Int64
    @NSManaged public var priority: String?
    @NSManaged public var taskColor: String?
    @NSManaged public var textColor: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?

}
