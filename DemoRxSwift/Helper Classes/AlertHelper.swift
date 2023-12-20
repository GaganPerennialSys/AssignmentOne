//
//  AlertHelper.swift
//  DemoRxSwift
//

import Foundation
import UIKit

class AlertHelper {
    
    static func showAddItemAlert(in viewController: UIViewController, addActionHandler: @escaping (String, String?, Date) -> Void) {
        let alertController = UIAlertController(title: "Add Todo Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Title"
        }

        alertController.addTextField { textField in
            textField.placeholder = "Description (optional)"
        }

        alertController.addTextField { textField in
            let dateTextField = UITextField()
            dateTextField.placeholder = "Date"
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .dateAndTime
            dateTextField.inputView = datePicker
            alertController.textFields?.last?.inputView = dateTextField.inputView
            alertController.textFields?.last?.text = DateFormatterHelper.shared.string(from: datePicker.date, format: "yyyy-MM-dd HH:mm")
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let title = alertController.textFields?[0].text, !title.isEmpty {
                let description = alertController.textFields?[1].text
                let dateText = alertController.textFields?[2].text
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                if let dateTime = dateText, let date = dateFormatter.date(from: dateTime) {
                    addActionHandler(title, description, date)
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        viewController.present(alertController, animated: true, completion: nil)
    }

    static func showEditItemAlert(in viewController: UIViewController, title: String, description: String?, dateTime: Date?, editActionHandler: @escaping (String, String?, Date) -> Void) {
        let alertController = UIAlertController(title: "Edit Todo Item", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Title"
            textField.text = title
        }

        alertController.addTextField { textField in
            textField.placeholder = "Description (optional)"
            textField.text = description
        }

        alertController.addTextField { textField in
            textField.placeholder = "Date"
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .dateAndTime
            datePicker.date = dateTime ?? Date()
            textField.text = DateFormatterHelper.shared.string(from: datePicker.date, format: "yyyy-MM-dd HH:mm")
            textField.inputView = datePicker
        }

        let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
            if let title = alertController.textFields?[0].text, !title.isEmpty {
                let description = alertController.textFields?[1].text
                let dateText = alertController.textFields?[2].text
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                if let dateTime = dateText, let date = dateFormatter.date(from: dateTime) {
                    editActionHandler(title, description, date)
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(editAction)
        alertController.addAction(cancelAction)

        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showLoginFailureAlert(in viewController: UIViewController) {
           let alert = UIAlertController(title: "Login Failed", message: "Invalid username or password", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alert.addAction(okAction)
           viewController.present(alert, animated: true, completion: nil)
       }
}
