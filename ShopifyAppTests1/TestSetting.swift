//
//  TestSetting.swift
//  ShopifyAppTests1
//
//  Created by Donia Ashraf on 6/19/21.
//

import XCTest
@testable import ShopifyApp
class TestSetting: XCTestCase {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let settingVm = SettingViewModel()
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
    func testSettig(){
        var currency = settingVm.getCurrency(key: "currency")
        XCTAssertEqual(currency, "USD")
        let hasAdd = settingVm.hasAddress(appDelegate: &appDelegate)
        XCTAssertTrue(hasAdd)
        let addr = settingVm.getAddress(appDelegate: &appDelegate)
        XCTAssertEqual(addr.city, "suez")
        settingVm.setCurrency(key: "currency", value: "USD")
        currency = settingVm.getCurrency(key: "currency")
               XCTAssertEqual(currency, "USD")
        let isLoggedIn = settingVm.isLoggedIn()
//        XCTAssertTrue(!isLoggedIn)
         XCTAssertTrue(isLoggedIn)
        settingVm.logout(appDelegate: &appDelegate)
        settingVm.bindSettingViewModel = {
            if let  isLoggedIn = self.settingVm.logout{
                 XCTAssertTrue(!isLoggedIn)
            }
        }
        
    }

}
