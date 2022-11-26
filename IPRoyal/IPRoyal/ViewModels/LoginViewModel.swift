//
//  LoginViewModel.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-26.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var emailState: TextFieldState = .neutral
    @Published var passwordState: TextFieldState = .neutral
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupObservers()
    }
    
    func login() {
        validateUserInput()
        
        guard emailState == .neutral, passwordState == .neutral else {
            return
        }
        
        
    }
    
    func setupObservers() {
        $email.sink { [weak self] _ in
            self?.emailState = .neutral
        }.store(in: &cancellables)
        
        $password.sink { [weak self] _ in
            self?.passwordState = .neutral
        }.store(in: &cancellables)
    }
    
    func validateUserInput() {
        if email.isEmail {
            emailState = .neutral
        } else {
            emailState = .error("Invalid email format")
        }
        
        if password.isValidPassword {
            passwordState = .neutral
        } else {
            passwordState = .error("Password must contain at least \(Config.passwordMinimumLength) characters")
        }
    }
}
