//
//  AppCoordinatorView.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-26.
//

import Foundation
import SwiftUI

struct AppCoordinatorView: View {
    
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        NavigationView {
            LoginView(model: coordinator.loginViewModel)
                .navigation(item: $coordinator.userListViewModel) { model in
                    UserListView(model: model)
                }
        }
    }
}
