//
//  LoginViewController.swift
//  DemoRxSwift


import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: Variables
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: View Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    //MARK: Methods
    //Setup Bindings here
    private func setupBindings() {
        // Bind the username from the text field to the view model
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed( by: disposeBag)
        
        // Enable the login button when there is text in the username field
        viewModel.isLoginEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // Handle login button tap
        loginButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance) // Throttle to prevent rapid taps
            .subscribe(onNext: { [weak self] in
                self?.performLogin()
            })
            .disposed(by: disposeBag)
    }
    
    //This method is performing login operation
    private func performLogin() {
        viewModel.login { [weak self] username in
            if let username = username {
                self?.performSegue(withIdentifier: "showTodo", sender: username)
            } else {
                // Handle login failure
                if let self = self {
                    AlertHelper.showLoginFailureAlert(in: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTodo" {
            if let destinationVC = segue.destination as? TodoViewController {
                if let username = sender as? String {
                    // Pass the user name to the TodoViewController
                    destinationVC.username = username
                }
            }
        }
    }
}
