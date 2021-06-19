//
//  LocalStorgeTests.swift
//  ShopifyAppTests1
//
//  Created by Donia Ashraf on 6/18/21.
//

import XCTest
@testable import ShopifyApp
class LocalStorgeTests: XCTestCase {
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaultsRepository = UserDefaultsLayer()
//    let local = CoreDataRepository(appDelegate: &appDelegate)
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
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
    func testCurrency() {
        var currency = defaultsRepository.getCurrency()
       XCTAssertEqual(currency, "USD")
       defaultsRepository.setCurrency(key: "currency", value: "USD")
        currency = defaultsRepository.getCurrency()
        XCTAssertEqual(currency, "USD")
    }
    func testgetUserName(){
       var userName =  defaultsRepository.getUserName()
//        XCTAssertEqual(userName,"Donia")
        XCTAssertEqual(userName,"")
        defaultsRepository.addUserName(userName: "donia")
        userName = defaultsRepository.getUserName()
        XCTAssertEqual(userName, "donia")
    }
    func testAddID(){
        defaultsRepository.addId(id: 5)
        XCTAssertTrue(defaultsRepository.getId() == 5)
    }
    func testISLoggedIn(){
       let isLoggedIn = defaultsRepository.isLoggedIn()
 //       XCTAssertTrue(isLoggedIn)
    //    XCTAssertTrue(!isLoggedIn)

    }
    func testLogout (){
        defaultsRepository.logut()
         let isLoggedIn = defaultsRepository.isLoggedIn()
        XCTAssertTrue(!isLoggedIn)
    }
    func testLogin(){
        defaultsRepository.login()
         let isLoggedIn = defaultsRepository.isLoggedIn()
         XCTAssertTrue(isLoggedIn)
        
    }
    func testDiscount(){
        var discount = defaultsRepository.getDiscountCode()
        XCTAssertEqual(discount, "SUMMERSALE100FF")
        defaultsRepository.setDiscountCode(code: "SUMMERSALE100FF")
        discount = defaultsRepository.getDiscountCode()
        XCTAssertEqual(discount, "SUMMERSALE100FF")
    }
    ///////// Core Data
    

}
