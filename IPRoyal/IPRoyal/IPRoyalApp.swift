//
//  IPRoyalApp.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-26.
//

import SwiftUI

@main
struct IPRoyalApp: App {
    
    let coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: coordinator)
        }
    }
}
