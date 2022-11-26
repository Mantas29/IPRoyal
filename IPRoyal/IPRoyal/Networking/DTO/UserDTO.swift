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
    
    init?(userResponse: UserResponse) {
        
        guard let result = userResponse.results.first else {
            return nil
        }
        
        name = result.name.first
        surname = result.name.last
        email = result.email
        address = "\(result.location.street.name) \(result.location.street.name), \(result.location.city), \(result.location.country)"
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
