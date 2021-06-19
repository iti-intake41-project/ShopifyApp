//
//  ShoppingBagViewModel.swift
//  ShopifyAppTests1
//
//  Created by Donia Ashraf on 6/18/21.
//

import XCTest
@testable import ShopifyApp
class TestShoppingBagViewModel: XCTestCase {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var shoppingViewModel: ShoppingBagViewModelTemp!
    var shoppingViewModel: ShoppingBagViewModel!
    var product1:Product!
    var product2:Product!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    //    shoppingViewModel = ShoppingBagViewModel()
        shoppingViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
         product1 = Product(id: 1, title: "shoes", description: "", vendor: "", productType: "", images: [ProductImage(id: 1, productID: 1, position: 1, width: 20, height: 20, src: "", graphQlID: "")], options: nil, varients: nil)
         product2 = Product(id: 2, title: "t- shirt", description: "", vendor: "", productType: "", images: [ProductImage(id: 1, productID: 1, position: 1, width: 20, height: 20, src: "", graphQlID: "")], options: nil, varients: nil)
           
        appDelegate.saveContext()
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

    func testCart(){
        let expect = expectation(description: "1")
        let expect2 = expectation(description: "2")

        shoppingViewModel.addProduct(product: product1)
        var products = shoppingViewModel.getShoppingCartProductList()
        XCTAssertEqual(products.count, 1)
        shoppingViewModel.deleteProduct(id: 1)
        products = shoppingViewModel.getShoppingCartProductList()
        expect.fulfill()
        XCTAssertEqual(products.count, 1)
        let currency = shoppingViewModel.getCurrency()
        XCTAssertEqual(currency, "USD")
       let isInCart =  shoppingViewModel.isInShopingCart(id: 0)
        XCTAssertTrue(isInCart)
        shoppingViewModel.updateProductList(id: 1, product: product2)
        expect2.fulfill()
        XCTAssertEqual(products[0].title, "shoes")
        shoppingViewModel.navigateToCheckOut()
        shoppingViewModel.postOrder(products: &products)
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    func testFav(){
        var favourites = shoppingViewModel.getAllFaourites()
     //   XCTAssertEqual(favourites.count, 7)
        let isfav = shoppingViewModel.isFavourite(id: 39853310378182)
        XCTAssertTrue(!isfav)
        shoppingViewModel.addFavourite(product: product1)
        favourites = shoppingViewModel.getAllFaourites()
        XCTAssertEqual(favourites.count, 1)
        shoppingViewModel.deleteFavourite(id: 2)
        XCTAssertEqual(favourites.count, 1)


    }
}
