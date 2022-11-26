//
//  Buttons.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-26.
//

import SwiftUI

struct MainButton: View {
    
    let action: () -> Void
    let title: String
    var background = Color.black
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .font(.subheadline)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(background)
                .cornerRadius(Config.uiCornerRadius)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        MainButton(action: { print("Clicked") }, title: "Main Button")
            .padding()
    }
}
