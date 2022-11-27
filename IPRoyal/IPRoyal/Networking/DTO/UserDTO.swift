//
//  UserDTO.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-26.
//

import Foundation

// MARK: - User

struct User: Identifiable {
    var id: String {
        return email
    }
    
    let name: String
    let surname: String
    let email: String
    let address: String
    let pictureURL: URL?
    
    init(userResult: UserResult) {
        name = userResult.name.first
        surname = userResult.name.last
        email = userResult.email
        address = "\(userResult.location.street.name) \(userResult.location.street.name), \(userResult.location.city), \(userResult.location.country)"
        pictureURL = URL(string: userResult.picture.large)
    }
    
    func contains(_ text: String) -> Bool {
        for data in [name, surname, email, address] {
            if data.lowercased().contains(text.lowercased()) {
                return true
            }
        }
        
        return false
    }
}

// MARK: - Response

struct UserResponse: Decodable {
    let results: [UserResult]
}

struct UserResult: Decodable {
    let name: UserName
    let location: UserLocation
    let email: String
    let picture: Picture
}

// MARK: - User Name

struct UserName: Decodable {
    let first: String
    let last: String
}

// MARK: - User Address

struct UserLocation: Decodable {
    let street: UserStreet
    let city: String
    let country: String
}

struct UserStreet: Decodable {
    let number: Int
    let name: String
}

// MARK: - Picture

struct Picture: Decodable {
    let large: String
}
