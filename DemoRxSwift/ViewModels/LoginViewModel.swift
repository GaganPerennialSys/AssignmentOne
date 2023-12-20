//
//  LoginViewModel.swift
//  DemoRxSwift

import Foundation
import RxSwift
import RxCocoa
import CoreData

class LoginViewModel {
    //MARK: Variables
    private let userRepository = UserRepository.shared
    private let disposeBag = DisposeBag()

    // BehaviorRelay with default user Admin
    let username = BehaviorRelay<String?>(value: nil)

    // Output
    let isLoginEnabled: Observable<Bool>

    init() {
        isLoginEnabled = username
            .map { !($0?.isEmpty ?? false) }
            .asObservable()
    }

    func login(completion: @escaping (String?) -> Void) {
        guard username.value != nil else {return}
        userRepository.login(username: username.value!)
            .subscribe(onNext: { [weak self] username in
                self?.handleLoginResult(username: username, completion: completion)
            })
            .disposed(by: disposeBag)
    }

    private func handleLoginResult(username: String?, completion: @escaping (String?) -> Void) {
        if let username = username {
            completion(username)
        } else {
            completion(nil)
        }
    }
}
