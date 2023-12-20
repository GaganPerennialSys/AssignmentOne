//
//  UserRepository.swift
//  DemoRxSwift
//


import Foundation
import RxSwift
import RxCocoa
import CoreData

class UserRepository {
    static let shared = UserRepository()
    private let disposeBag = DisposeBag()

    // Simulate login logic
    func login(username: String) -> Observable<String?> {
        // Check if the user exists in Core Data
        return Observable.create { observer in
            if let existingUser = self.getUserByUsername(username) {
                observer.onNext(existingUser.username)
            }
            else {
//                // Create a new user in Core Data
//                let newUser = User(context: CoreDataStack.shared.context)
//                newUser.username = username
//                newUser.userID = UUID().uuidString
//                CoreDataStack.shared.saveContext()
                observer.onNext(nil)
           }

            observer.onCompleted()

            return Disposables.create()
        }
    }

    // Simulate getting a user by username
    func getUserByUsername(_ username: String) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            let users = try CoreDataStack.shared.context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
}
