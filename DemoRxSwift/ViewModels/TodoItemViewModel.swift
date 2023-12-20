//
//  TODOViewModel.swift
//  DemoRxSwift


import Foundation
import RxSwift
import RxCocoa

class TodoItemViewModel {
    //MARK: Variables
    var todoItems = BehaviorRelay<[TodoItemEntity]>(value: [])
    private let todoItemRepository = TodoItemRepository.shared
    private let currentUsername = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    init() {}
    
    //MARK: View Model Methods
    //Set UserID here
    func setLoggedInUsername(_ username: String) {
        currentUsername.accept(username)
        reloadData()
        
    }
    // Reload data calls everytime when any CRUD operations occurs
    private func reloadData() {
        //TODO: Need to change the direct intraction between Core data and View Model
        //Thinking of adding seperate UI models
        todoItemRepository.getTodoItems(forUserID: currentUsername.value)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] items in
                self?.todoItems.accept(items)
            })
            .disposed(by: disposeBag)
    }
    //MARK: CRUD Operations Methods
    //call this method for add any Todo
    func addTodoItem(title: String, descriptionText: String?, dateTime: Date) {
        guard currentUsername.value != "" else {
            return
        }
        todoItemRepository.addTodoItem(forUserID: currentUsername.value, title: title, descriptionText: descriptionText, dateTime: dateTime)
        reloadData()
    }

    //call this method for delete any Todo
    func deleteTodoItem(at index: Int) {
        guard currentUsername.value != "" else {
            return
        }
        todoItemRepository.deleteTodoItem(forUserID: currentUsername.value, at: index)
        reloadData()
    }

    //call this method for update any Todo
    func updateTodoItem(at index: Int, withTitle title: String, descriptionText: String?, dateTime: Date) {
        guard currentUsername.value != "" else {
            return
        }
        todoItemRepository.updateTodoItem(forUserID: currentUsername.value, at: index, withTitle: title, descriptionText: descriptionText, dateTime: dateTime)
        reloadData()
    }
}
