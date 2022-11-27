//
//  UsersViewModel.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-26.
//

import Combine
import Foundation

class UsersViewModel: ObservableObject {
    
    enum UserListState {
        case loading
        case finished([User])
        case error(String)
        
        var isFinished: Bool {
            if case .finished = self { return true }
            return false
        }
        
        var isError: Bool {
            if case .error = self { return true }
            return false
        }
    }
    
    let userService: UsersService
    private var usersObserver: AnyCancellable?
    private var searchTextObserver: AnyCancellable?
    
    @Published var state: UserListState = .loading
    @Published var searchText = ""
    @Published var searchResults: [User] = []
    
    init(userService: UsersService = DefaultUsersService()) {
        self.userService = userService
        setupSearchTextObserver()
        get3RandomUsers()
    }
    
    // This is a simplified approach that takes advantage of built in Zip3 Combine method.
    // In order to have scalability, a solution with unlimited requests should be implemented.
    func get3RandomUsers() {
        
        state = .loading
        
        var users: [User] = []
        
        usersObserver = Publishers.Zip3(userService.getRandomUsers(),
                                        userService.getRandomUsers(),
                                        userService.getRandomUsers()).sink { [weak self] (r1, r2, r3) in
            
            guard let self else { return }
            
            for result in [r1, r2, r3] {
                switch result {
                case .success(let response):
                    if let result = response.results.first {
                        let user = User(userResult: result)
                        users.append(user)
                    } else {
                        self.state = .error("Could not retrieve all of the users")
                        return
                    }
                case .failure(let error):
                    self.state = .error(error.localizedDescription)
                    return
                }
            }
            
            self.state = .finished(users)
            self.filterUsers(thatContain: self.searchText)
        }
    }
    
    private func setupSearchTextObserver() {
        searchTextObserver = $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.filterUsers(thatContain: text)
            }
    }
    
    private func filterUsers(thatContain text: String) {
        guard case .finished(let users) = state else {
            return
        }
        
        if text.isEmpty {
            searchResults = users
            return
        }
        
        searchResults = users.filter { $0.contains(text) }
    }
}
