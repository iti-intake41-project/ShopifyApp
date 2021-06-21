//
//  TestMeViewModel.swift
//  ShopifyAppTests1
//
//  Created by Donia Ashraf on 6/19/21.
//

import XCTest
@testable import ShopifyApp
class TestMeViewModel: XCTestCase {
    let meViewModel = MeViewModel()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

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

    func testMe(){
        let expect = expectation(description: "expect")
        let expect2 = expectation(description: "expecting")

        var orders =  meViewModel.getOrders()
        meViewModel.bindOrders = {
            orders = self.meViewModel.orders
            expect.fulfill()
            XCTAssertTrue(orders.count > 0)
        }
        meViewModel.updateOrders = {
                let ordersItems = self.meViewModel.orderItems
                   expect2.fulfill()
                   XCTAssertTrue(ordersItems.count == 0)
               }
        let favourites = meViewModel.getfavourites(appDelegate: &appDelegate)
//        XCTAssertTrue(favourites.count > 3)
        XCTAssertTrue(favourites.count != 3)
        let userNaame = meViewModel.getUserName()
//        XCTAssertEqual(userNaame, "Donia")
        XCTAssertEqual(userNaame, "donia")
        let isloggedIn = meViewModel.isLoggedIn()
    //    XCTAssertTrue(!isloggedIn)
        XCTAssertTrue(isloggedIn)
        waitForExpectations(timeout: 40, handler: nil)
    }
    
}
