//
//  ShopifyAppTests1.swift
//  ShopifyAppTests1
//
//  Created by Donia Ashraf on 6/17/21.
//

import XCTest
@testable import ShopifyApp

class ShopifyAppTests1: XCTestCase {
    var network :NetworkLayer!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        network = NetworkLayer()
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
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testProducts(){
        let expect = expectation(description: "expecting")
        network.getProducts(collectionID: "268359598278"){ (products, error) in
            if let error = error{
                XCTFail()
            }else{
                expect.fulfill()
                XCTAssertNotEqual(products?.count,0)
                
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testCollections() {
        let expect = expectation(description: "expecting")
        
        network.getCategories(){
            (collections , error) in
            if let error = error {
                XCTFail()
            }else {
                expect.fulfill()
                //  count = 2 failed
                XCTAssertEqual(collections?.count, 5)
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    func testsmartCollections() {
        let expect = expectation(description: "expect")
        network.getSmartCollections(){
            (smartCollections , error ) in
            if let error = error {
                XCTFail()
            }else{
                expect.fulfill()
              //  XCTAssertEqual(smartCollections?.count, 0)
                XCTAssertNotEqual(smartCollections?.count, 2)
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testDiscount () {
        let expect = expectation(description: "expect")
        network.getDiscountCode(priceRuleID: "950161080518") {
            (codes , error ) in
            if let error = error {
                XCTFail()
            }else{
                expect.fulfill()
                XCTAssertEqual(codes?.count, 1)
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
//    func testgetOrders() {
//        let expect = expectation(description: "expect")
//        var orders = [Order]()
//              network.getOrders { (response) in
//               switch response.result {
//               case .success(let result):
//               //   print("result: \(result)")
//                   orders = result.orders
//                  print("orders count \(orders.count)")
//                   expect.fulfill()
//                   XCTAssertEqual(orders.count, 5)
//               case .failure(let error):
//                   print("error while getting orders: \(error.localizedDescription)")
//                XCTFail()
//               }
//
//           }
//        waitForExpectations(timeout: 3, handler: nil)
//    }
    
    
}
