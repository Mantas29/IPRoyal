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

private let userResultMock = UserResult(name: UserName(first: "first",
                                                       last: "last"),
                                        location: UserLocation(street: .init(number: 123, name: "name"),
                                                               city: "city",
                                                               country: "country"),
                                        email: "email",
                                        picture: Picture(large: "large"))


private class UsersServiceMock: UsersService {
    
    enum ReturnType {
        case success(UserResult)
        case failure(ResponseError)
    }
    
    var returnType: ReturnType = .failure(ResponseError(localizedDescription: "Default error"))
    
    func getRandomUsers() -> AnyPublisher<Result<UserResponse, ResponseError>, Never> {
        switch returnType {
        case .success(let result):
            return Just(.success(UserResponse(results: [result]))).eraseToAnyPublisher()
        case .failure(let error):
            return Just(.failure(error)).eraseToAnyPublisher()
        }
    }
    
    
}

final class UsersViewModelTests: XCTestCase {
    
    private var model: UsersViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        model = UsersViewModel()
    }

    override func tearDownWithError() throws {
        model = UsersViewModel()
    }
    
    func testGetRandomUsers_success() {
        let mock = UsersServiceMock()
        mock.returnType = .success(userResultMock)
        
        model = UsersViewModel(userService: mock)
        
        let expectation = expectation(description: "Received random users")
        
        model.$state
            .dropFirst()
            .filter(\.isFinished)
            .sink { state in
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
    
    func testGetRandomUsers_failure() {
        let mock = UsersServiceMock()
        mock.returnType = .failure(.init(localizedDescription: "Failed"))
        
        model = UsersViewModel(userService: mock)
        
        let expectation = expectation(description: "Failed receiving random users")
        
        model.$state
            .dropFirst()
            .filter(\.isError)
            .sink { state in
                expectation.fulfill()
            }.store(in: &cancellables)

        // When
        model.get3RandomUsers()
        
        waitForExpectations(timeout: 2)

        // Then
        XCTAssertTrue(model.state.isError)
        XCTAssertEqual(model.searchResults.count, 0)
    }
}
