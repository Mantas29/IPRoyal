//
//  UsersView.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-26.
//

import SwiftUI

struct UsersView: View {
    
    @ObservedObject var model: UsersViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Search")
                .font(.title2)
                .fontWeight(.bold)
            
            MainTextField(title: "Search for name, phone, account number...",
                          text: $model.searchText,
                          state: .constant(.neutral))
            
            VStack {
                switch model.state {
                case .loading:
                    ProgressView()
                case .finished:
                    UserListView(users: model.searchResults)
                case .error(let message):
                    ErrorView(message: message, retryAction: model.get3RandomUsers)
                }
            }
            .frame(maxHeight: .infinity)
            
            Spacer()
        }
        .padding()
    }
}

private struct ErrorView: View {
    
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .font(.headline)
                .fontWeight(.bold)
            MainButton(action: retryAction, title: "Retry", background: .yellow)
        }
    }
}

private struct UserListView: View {
    
    let users: [User]
    
    var body: some View {
        if users.isEmpty {
            Text("Nothing found")
                .font(.title)
                .fontWeight(.bold)
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(users) { user in
                        UserRowView(user: user)
                    }
                }
            }
        }
    }
}

private struct UserRowView: View {
    
    let user: User
    
    var body: some View {
        HStack {
            profilePicture
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading) {
                Text("\(user.name) \(user.surname)")
                    .fontWeight(.bold)
                Text(user.email)
                Text(user.address)
                
                Divider()
            }
            .multilineTextAlignment(.leading)
            .font(.subheadline)
        }
    }
    
    var profilePicture: some View {
        AsyncImage(url: user.pictureURL) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
    }
}
