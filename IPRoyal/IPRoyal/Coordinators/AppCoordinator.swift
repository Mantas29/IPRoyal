//
//  AppCoordinator.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-26.
//

import Foundation

class AppCoordinator: ObservableObject {
    
    lazy var loginViewModel = LoginViewModel(coordinator: self)
    @Published var userListViewModel: UserListViewModel?
}

extension AppCoordinator: AppCoordinatorProtocol {
    func openUserList() {
        userListViewModel = UserListViewModel()
    }
}
