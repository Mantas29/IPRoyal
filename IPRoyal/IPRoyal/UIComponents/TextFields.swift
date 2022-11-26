//
//  TextFields.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-26.
//

import SwiftUI

private enum Const {
    static let defaultBackground = Color(red: 236 / 255, green: 236 / 255, blue: 236 / 255)
    static let errorColor = Color(red: 212 / 255, green: 61 / 255, blue: 61 / 255)
}

enum TextFieldState: Equatable {
    case neutral
    case error(String)
    
    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
}

struct MainTextField: View {
    
    let title: String
    @Binding var text: String
    @Binding var state: TextFieldState
    var isSecure = false
    
    var backgroundColor = Const.defaultBackground
    
    var body: some View {
        VStack {
            VStack {
                if isSecure {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            .foregroundColor(state.isError ? Const.errorColor : .black)
            .font(.subheadline)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(backgroundColor)
            .cornerRadius(Config.uiCornerRadius)
            .overlay(border)
            
            message
        }
    }
    
    @ViewBuilder
    private var border: some View {
        if case .error = state {
            RoundedRectangle(cornerRadius: Config.uiCornerRadius)
                .stroke(Const.errorColor, lineWidth: 1)
        }
    }
    
    @ViewBuilder
    private var message: some View {
        if case .error(let message) = state {
            Text(message)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Const.errorColor)
                .padding(.leading, 4)
        }
    }
}

struct TextFields_Previews: PreviewProvider {
    static var previews: some View {
        MainTextField(title: "Main Text Field", text: .constant(""), state: .constant(.error("Something went wrong")))
            .padding()
    }
}
