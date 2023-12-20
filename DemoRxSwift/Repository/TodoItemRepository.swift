//
//  TodoItemRepository.swift
//  DemoRxSwift
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

///This class follows the repository pattern
///Use this class for any operations related to coredata todo list opeartions
class TodoItemRepository {
    //MARK: Variables
    static let shared = TodoItemRepository()
    private let context = CoreDataStack.shared.context

    //MARK: CRUD Operations Methods
    //This method is use to get todo items
    func getTodoItems(forUserID userID: String) -> Observable<[TodoItemEntity]> {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", userID)

        return Observable.create { observer in
            do {
                let users = try self.context.fetch(fetchRequest)
                if let user = users.first, let todoItems = user.todoItems?.allObjects as? [TodoItemEntity] {
                    observer.onNext(todoItems)
                    observer.onCompleted()
                } else {
                    observer.onNext([])
                    observer.onCompleted()
                }
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }
    
    //This method is use to add todo items
    func addTodoItem(forUserID userID: String, title: String, descriptionText: String?, dateTime: Date) {
        guard let user = UserRepository.shared.getUserByUsername(userID) else { return }

        let newTodoItem = TodoItemEntity(context: context)
        newTodoItem.id = UUID()
        newTodoItem.title = title
        newTodoItem.discription = descriptionText
        newTodoItem.dateTime = dateTime
        newTodoItem.user = user

        CoreDataStack.shared.saveContext()
    }
    
   //This method is use to delete todo items
    func deleteTodoItem(forUserID userID: String, at index: Int) {

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", userID)

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first, let todoItems = user.todoItems?.allObjects as? [TodoItemEntity] {
                guard index < todoItems.count else { return }

                let todoItemToDelete = todoItems[index]
                context.delete(todoItemToDelete)

                CoreDataStack.shared.saveContext()
            }
        } catch {
            print("Error deleting todo item: \(error)")
        }
    }
    //This method is use to update todo items
    func updateTodoItem(forUserID userID: String, at index: Int, withTitle title: String, descriptionText: String?, dateTime: Date) {

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", userID)

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first, let todoItems = user.todoItems?.allObjects as? [TodoItemEntity] {
                guard index < todoItems.count else { return }

                let todoItemToUpdate = todoItems[index]
                todoItemToUpdate.title = title
                todoItemToUpdate.discription = descriptionText
                todoItemToUpdate.dateTime = dateTime

                CoreDataStack.shared.saveContext()
            }
        } catch {
            print("Error updating todo item: \(error)")
        }
    }
}

