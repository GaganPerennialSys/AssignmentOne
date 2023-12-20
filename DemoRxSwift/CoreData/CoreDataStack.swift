//
//  CoreDataStack.swift
//  DemoRxSwift
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DemoRxSwift")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func addDefaultUsersIfNeeded() {
           let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
           fetchRequest.fetchLimit = 2

           do {
               let userCount = try context.count(for: fetchRequest)
               if userCount == 0 {
                   // Add default users
                   let user1 = User(context: context)
                   user1.username = "GaganOne"

                   let user2 = User(context: context)
                   user2.username = "Admin"

                   try context.save()
               }
           } catch {
               print("Failed to fetch user count: \(error)")
           }
       }
    
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.localizedDescription)")
            }
        }
    }
}
