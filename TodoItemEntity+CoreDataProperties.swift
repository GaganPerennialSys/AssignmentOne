//
//  TodoItemEntity+CoreDataProperties.swift
//  
//

import Foundation
import CoreData


extension TodoItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItemEntity> {
        return NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
    }

    @NSManaged public var dateTime: Date?
    @NSManaged public var discription: String?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var user: User?

}
