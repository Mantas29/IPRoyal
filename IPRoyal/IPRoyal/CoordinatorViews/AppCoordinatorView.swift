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
                .navigation(item: $coordinator.usersViewModel) { model in
                    UsersView(model: model)
                        .navigationBarHidden(true)
                }
        }
        .navigationViewStyle(.stack)
    }
}
