//
//  ViewModelTests.swift
//  ShopifyAppTests1
//
//  Created by Donia Ashraf on 6/18/21.
//

import XCTest
@testable import ShopifyApp
class ViewModelTests: XCTestCase {
    let showViewModel = ShopViewModel()
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
    // Shop View Model
    func testProducts(){
        let expext = expectation(description: "expect")
        showViewModel.fetchAllProductsFromAPI()

        showViewModel.bindShopViewModelToView = {
            expext.fulfill()
            let products = self.showViewModel.allProducts
            XCTAssertEqual(products?.count, 20)

        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    func testCollections(){
        let expext = expectation(description: "expect")
        showViewModel.fetchCustomCollection()

        showViewModel.bindCategoryViewModelToView = {
            expext.fulfill()
            let collections = self.showViewModel.customCollections
            XCTAssertEqual(collections?.count, 5)

        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    func testSmartCollections(){
           let expext = expectation(description: "expect")
           showViewModel.fetchSmartCollection()

           showViewModel.bindsmartCollectionsViewModelToView = {
               expext.fulfill()
            let collections = self.showViewModel.smartCollections
               XCTAssertEqual(collections?.count, 12)

           }
           waitForExpectations(timeout: 3, handler: nil)
       }
    func testSearch () {
        let collections : [CustomCollections] = [
            CustomCollections(id: 1, title: "ADIDAS", image: CollectionImage(width: 20.2, height: 20, src: "")),
              CustomCollections(id: 1, title: "ASICS TIGER", image: CollectionImage(width: 20.2, height: 20, src: "")),
              CustomCollections(id: 1, title: "CONVERSE", image: CollectionImage(width: 20.2, height: 20, src: ""))
        ]
       var result : [CustomCollections]?
       result = showViewModel.searchProduct(sProducts: collections, searchTxt: "adidas")
        XCTAssertTrue(result!.count > 0 )
    
    }
    func testAdds() {
        let expext = expectation(description: "expect")
        showViewModel.fetchAdds()
        showViewModel.bindAddsViewModelToView = {
            expext.fulfill()
            let adds = self.showViewModel.adds
            XCTAssertEqual(adds?.count, 1 )
        }
        waitForExpectations(timeout: 3, handler: nil)

    }
    func testIsLoggedIn(){
      let isLoggedIn = showViewModel.isLoggedIn()
      XCTAssertTrue(isLoggedIn)
    }
}
