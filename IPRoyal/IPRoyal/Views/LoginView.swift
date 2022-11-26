//
//  LoginView.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-26.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var model: LoginViewModel
    
    var body: some View {
        VStack(spacing: 14) {
            
            Text("Login")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer().frame(height: 70)
            
            MainTextField(title: "Email", text: $model.email, state: $model.emailState)
                .keyboardType(.emailAddress)
            MainTextField(title: "Password", text: $model.password, state: $model.passwordState, isSecure: true)
            
            MainButton(action: model.login, title: "Login")
        }
        .padding()
    }
}
