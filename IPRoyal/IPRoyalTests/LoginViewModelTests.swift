//
//  LoginViewModelTests.swift
//  IPRoyalTests
//
//  Created by m.skeiverys on 2022-11-27.
//

import XCTest
@testable import IPRoyal

private class Coordinator: AppCoordinatorProtocol {
    
    var userViewOpened = false
    
    func openUsersView() {
        userViewOpened = true
    }
}

final class LoginViewModelTests: XCTestCase {
    
    private var model: LoginViewModel!
    private var coordinator: Coordinator!

    override func setUpWithError() throws {
        coordinator = Coordinator()
        model = LoginViewModel(coordinator: coordinator)
    }

    override func tearDownWithError() throws {
        coordinator = Coordinator()
        model = LoginViewModel(coordinator: coordinator)
    }

    func testEmailState_valid() {
        XCTAssertEqual(model.emailState, .neutral)
        
        model.email = "test.email@email.com"
        model.login()
        
        XCTAssertEqual(model.emailState, .neutral)
    }
    
    func testEmailState_invalid() {
        XCTAssertEqual(model.emailState, .neutral)
        
        model.email = "incorrect.format.com@"
        model.login()
        
        XCTAssertTrue(model.emailState.isError)
    }
    
    func testPasswordState_valid() {
        XCTAssertEqual(model.passwordState, .neutral)
        
        model.password = String(repeating: "A", count: Config.passwordMinimumLength)
        model.login()
        
        XCTAssertEqual(model.passwordState, .neutral)
    }
    
    func testPasswordState_invalid() {
        XCTAssertEqual(model.passwordState, .neutral)
        
        model.password = String(repeating: "A", count: Config.passwordMinimumLength - 1)
        model.login()
        
        XCTAssertTrue(model.passwordState.isError)
    }
    
    func testLogin_success() {
        XCTAssertEqual(model.emailState, .neutral)
        XCTAssertEqual(model.passwordState, .neutral)
        
        model.email = "real.email@email.com"
        model.password = "RealPassword123!!!"
        
        model.login()
        
        XCTAssertTrue(coordinator.userViewOpened)
    }
    
    func testLogin_failure() {
        XCTAssertEqual(model.emailState, .neutral)
        XCTAssertEqual(model.passwordState, .neutral)
        
        model.email = "invalid.password.com@"
        model.password = "RealPassword123!!!"
        
        model.login()
        
        XCTAssertFalse(coordinator.userViewOpened)
    }
}
