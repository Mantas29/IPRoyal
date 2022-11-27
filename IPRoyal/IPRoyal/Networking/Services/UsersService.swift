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
    func getRandomUsers() -> AnyPublisher<Result<UserResponse, ResponseError>, Never>
}

class DefaultUsersService: UsersService {
    
    func getRandomUsers() -> AnyPublisher<Result<UserResponse, ResponseError>, Never> {
        AF.request(Endpoints.randomUsersEndpoint,
                   method: .get)
        .validate()
        .publishDecodable(type: UserResponse.self)
        .map { $0.result }
        .map { $0.mapError(\.asResponseError) }
        .eraseToAnyPublisher()
    }
}
