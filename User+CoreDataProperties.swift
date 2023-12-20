//
//  User+CoreDataProperties.swift
//  

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userID: String?
    @NSManaged public var username: String?
    @NSManaged public var todoItems: NSSet?

}

// MARK: Generated accessors for todoItems
extension User {

    @objc(addTodoItemsObject:)
    @NSManaged public func addToTodoItems(_ value: TodoItemEntity)

    @objc(removeTodoItemsObject:)
    @NSManaged public func removeFromTodoItems(_ value: TodoItemEntity)

    @objc(addTodoItems:)
    @NSManaged public func addToTodoItems(_ values: NSSet)

    @objc(removeTodoItems:)
    @NSManaged public func removeFromTodoItems(_ values: NSSet)

}
