//
//  UsersViewModelTests.swift
//  IPRoyalTests
//
//  Created by m.skeiverys on 2022-11-27.
//

import XCTest
@testable import IPRoyal

import Alamofire
import Combine

private let userResultMock1 = UserResult(name: UserName(first: "first1",
                                                       last: "last1"),
                                        location: UserLocation(street: .init(number: 1, name: "name1"),
                                                               city: "city1",
                                                               country: "country1"),
                                        email: "email1",
                                        picture: Picture(large: "large1"))

private let userResultMock2 = UserResult(name: UserName(first: "first2",
                                                       last: "last2"),
                                        location: UserLocation(street: .init(number: 2, name: "name2"),
                                                               city: "city2",
                                                               country: "country2"),
                                        email: "email2",
                                        picture: Picture(large: "large2"))

private let userResultMock3 = UserResult(name: UserName(first: "first3",
                                                       last: "last3"),
                                        location: UserLocation(street: .init(number: 3, name: "name3"),
                                                               city: "city3",
                                                               country: "country3"),
                                        email: "email3",
                                        picture: Picture(large: "large3"))

private class UsersServiceMock: UsersService {
    
    enum ReturnType {
        case success([UserResult])
        case failure(ResponseError)
    }
    
    var returnType: ReturnType = .failure(ResponseError(localizedDescription: "Default error"))
    
    func getRandomUsers() -> AnyPublisher<Result<UserResponse, ResponseError>, Never> {
        switch returnType {
        case .success(let results):
            return Just(.success(UserResponse(results: results))).eraseToAnyPublisher()
        case .failure(let error):
            return Just(.failure(error)).eraseToAnyPublisher()
        }
    }
}

final class UsersViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
    }
    
    func testGetRandomUsers_success() {
        let mock = UsersServiceMock()
        let userResultMock = userResultMock1
        mock.returnType = .success([userResultMock])
        
        let model = UsersViewModel(userService: mock)
        
        let expectation = expectation(description: "Received random users")
        
        model.$state
            .dropFirst()
            .filter(\.isFinished)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &cancellables)
        
        // When
        model.get3RandomUsers()
        
        waitForExpectations(timeout: 2)
        
        // Then
        XCTAssertTrue(model.state.isFinished)
        XCTAssertEqual(model.searchResults.count, 3)
        XCTAssertEqual(model.searchResults.first?.email, userResultMock.email)
    }
    
    func testGetRandomUsers_empty() {
        let mock = UsersServiceMock()
        mock.returnType = .success([])
        
        let model = UsersViewModel(userService: mock)
        
        let expectation = expectation(description: "Received empty user")
        
        model.$state
            .dropFirst()
            .filter(\.isError)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &cancellables)
        
        // When
        model.get3RandomUsers()
        
        waitForExpectations(timeout: 2)
        
        // Then
        XCTAssertTrue(model.state.isError)
        XCTAssertEqual(model.searchResults.count, 0)
    }
    
    func testGetRandomUsers_failure() {
        let mock = UsersServiceMock()
        mock.returnType = .failure(.init(localizedDescription: "Failed"))
        
        let model = UsersViewModel(userService: mock)
        
        let expectation = expectation(description: "Failed receiving random users")
        
        model.$state
            .dropFirst()
            .filter(\.isError)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &cancellables)

        // When
        model.get3RandomUsers()
        
        waitForExpectations(timeout: 2)

        // Then
        XCTAssertTrue(model.state.isError)
        XCTAssertEqual(model.searchResults.count, 0)
    }
    
    func testSearchText_notEmpty() {
        let model = UsersViewModel()
        
        let user1 = User(userResult: userResultMock1)
        let user2 = User(userResult: userResultMock2)
        let user3 = User(userResult: userResultMock3)
        
        model.state = .finished([user1, user2, user3])
        
        let expecation = expectation(description: "Search results updated")
        
        model.$searchResults.dropFirst().sink { _ in
            expecation.fulfill()
        }.store(in: &cancellables)
        
        // When
        model.searchText = user1.name
        
        waitForExpectations(timeout: 2)
        
        // Then
        XCTAssertEqual(model.searchResults.count, 1)
        XCTAssertEqual(model.searchResults.first?.name, user1.name)
    }
    
    func testSearchText_empty() {
        let model = UsersViewModel()
        
        let user1 = User(userResult: userResultMock1)
        let user2 = User(userResult: userResultMock2)
        let user3 = User(userResult: userResultMock3)
        
        model.state = .finished([user1, user2, user3])
        model.searchText = user1.name
        
        let expecation = expectation(description: "Search results updated")
        
        model.$searchResults.dropFirst().sink { _ in
            expecation.fulfill()
        }.store(in: &cancellables)
        
        // When
        model.searchText = ""
        
        waitForExpectations(timeout: 2)
        
        // Then
        XCTAssertEqual(model.searchResults.count, 3)
    }
}
