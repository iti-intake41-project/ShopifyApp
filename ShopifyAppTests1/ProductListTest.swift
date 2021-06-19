//
//  ProductListTest.swift
//  ShopifyAppTests1
//
//  Created by Donia Ashraf on 6/18/21.
//

import XCTest
@testable import ShopifyApp
class ProductListTest: XCTestCase {

    let productListViewModel = ProductListViewModel()
    let productsViewController = ProductListViewController()
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

    func testProducts(){
        let expect = expectation(description: "expect")
        productListViewModel.fetchAllProductsFromAPI()
        productListViewModel.bindProductListViewModelToView = {
            if let products = self.productListViewModel.allProducts {
                expect.fulfill()
                XCTAssertTrue(products.count > 0 )
                XCTAssertEqual(products.count, 20)
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
        
    }
    func testProductSearch(){
        let product = Product(id: 5, title: "Shoes", description: "", vendor: "", productType: "", images: [ProductImage(id: 1, productID: 5, position: 0, width: 2, height: 2, src: "", graphQlID: "")], options: nil, varients: nil)
        let result = productListViewModel.searchProduct(sProducts: [product], searchTxt: "Shoes")
        XCTAssertEqual(result[0].title, "Shoes")
        
    }
    func testConnection(){
       let isCOnnected =  ConnectionViewModel.isConnected()
        XCTAssertTrue(isCOnnected)
    }
    func test() {
        let expect = expectation(description: "expect")
        
        productListViewModel.fetchAllProductsFromAPI()
        productListViewModel.bindProductListViewModelToView =     //productsViewController.onSuccessUpdateView
            {
                if let products = self.productListViewModel.allProducts {
                    self.productsViewController.products = products
        expect.fulfill()
        XCTAssertTrue(products.count > 0 )
                }else {
                    XCTFail()
                }
    }
        waitForExpectations(timeout: 3, handler: nil)

//          let product = Product(id: 5, title: "Shoes", description: "", vendor: "", productType: "", images: [ProductImage(id: 1, productID: 5, position: 0, width: 2, height: 2, src: "", graphQlID: "")], options: nil, varients: nil)
//        productsViewController.addFavourite(product: product)
//        let fav = productsViewController.favourites
//        expect.fulfill()
//        XCTAssertEqual(fav.count, 1)
    }
    func testFormatePrice(){
       let price = FormatePrice.formatePrice(priceStr: "1000")
        XCTAssertEqual(price, "USD \(Double(round(100*(1000 / 15.669931))/100))")
    }
    func testShowAlert(){
//        let vm = ShopViewController()
//        showAlert(view: vm)
    }
}
