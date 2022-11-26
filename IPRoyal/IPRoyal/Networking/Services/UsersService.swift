//
//  UsersService.swift
//  IPRoyal
//
//  Created by m.skeiverys on 2022-11-26.
//

import Alamofire
import Combine
import Foundation

private enum Endpoints {
    static let randomUsersEndpoint = "https://randomuser.me/api"
}

protocol UsersService {
    func getRandomUsers() -> DataResponsePublisher<UserResponse>
}

class DefaultUsersService: UsersService {
    
    func getRandomUsers() -> DataResponsePublisher<UserResponse> {
        AF.request(Endpoints.randomUsersEndpoint,
                   method: .get)
        .validate()
        .publishDecodable(type: UserResponse.self)
    }
}
