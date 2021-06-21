//
//  Login&Register.swift
//  ShopifyAppTests1
//
//  Created by Donia Ashraf on 6/19/21.
//

import XCTest
@testable import ShopifyApp
class Login_Register: XCTestCase {
    var loginVM:LoginViewModelTemp!
    var registerVM:RegisterViewModelTemp!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginVM = LoginViewModel(appDelegate: &appDelegate)
        registerVM = RegisterViewModel()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testLogin(){
        let expect = expectation(description: "d")
        loginVM.login(email: "donia100@gmail.com", password: "123456")
        loginVM.bindNavigate = {
            let navigate = self.loginVM.navigate
            expect.fulfill()
            XCTAssertTrue((navigate == true))
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    func testRegister(){
        let expect = expectation(description: "d")
        registerVM.registerCustomer(firstName: "donia", lastName: "", email: "donia15@gmail.com", password: "123456", confirmPassword: "123456")
        registerVM.navigateToMain = {
            expect.fulfill()
            XCTAssertTrue(true)
        }
        waitForExpectations(timeout: 20, handler: nil)

    }
}
