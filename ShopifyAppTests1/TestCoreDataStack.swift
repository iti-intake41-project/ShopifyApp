//
//  TestCoreDataStack.swift
//  ShopifyAppTests1
//
//  Created by Donia Ashraf on 6/18/21.
//

import XCTest
import CoreData
@testable import ShopifyApp
class TestCoreDataStack: XCTestCase {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
        }
        return container
    }()
    let product1 = Product(id: 1, title: "shoes", description: "", vendor: "", productType: "", images: [ProductImage(id: 1, productID: 1, position: 1, width: 20, height: 20, src: "", graphQlID: "")], options: nil, varients: nil)
    let product2 = Product(id: 2, title: "shoes", description: "", vendor: "", productType: "", images: [ProductImage(id: 1, productID: 1, position: 1, width: 20, height: 20, src: "", graphQlID: "")], options: nil, varients: nil)
    
    func testCoreData(){
        let expect = expectation(description: "")
        var context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        let mockCoreData = MockCoreDataRepository(delegate: &context)
        
        mockCoreData.addProduct(product: product1)
        mockCoreData.addProduct(product: product2)
        mockCoreData.deleteProduct(id: 5)
        //    expect.fulfill()
        
        let products = mockCoreData.getShoppingCartProductList()
        expect.fulfill()
        XCTAssertEqual(products.count, 1)
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testEmptyCart(){
        var context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        let mockCoreData = MockCoreDataRepository(delegate: &context)
        mockCoreData.emptyCart()
        let products = mockCoreData.getShoppingCartProductList()
        XCTAssertEqual(products.count, 0)
        
    }
    func testAddFav(){
        var context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        let mockCoreData = MockCoreDataRepository(delegate: &context)
        mockCoreData.addFavourite(product: product1)
        mockCoreData.addFavourite(product: product2)
     //   mockCoreData.deleteFavourite(id: 1)
        mockCoreData.updateProductList(id: 1, product: product2)
        let favourtites = mockCoreData.getFavourites()
        XCTAssertTrue(favourtites.count > 0)
        XCTAssertEqual(favourtites[1].id, 2)
    }
    func testAddress(){
        let expect = expectation(description: "expect")
        var context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        let mockCoreData:LocalDataRepository = MockCoreDataRepository(delegate: &context)
        let address = Address(address1: "suez11", city: "suez", province: nil, phone: "", zip: "", last_name: "", first_name: "Donia", country: "Egypt", id: 1)
        let address2 = Address(address1: "suez11", city: "suez", province: nil, phone: "", zip: "", last_name: "", first_name: "Donia", country: "Egypt", id: 2)
        mockCoreData.addAddress(address: address)
        mockCoreData.addAddress(address: address2)
        var addrs = mockCoreData.getAddresses()
        var addr = mockCoreData.getAddress()
        XCTAssertTrue(addr.city == "suez")
        XCTAssertEqual(addrs.count, 2)
        XCTAssertEqual(addr.id, 2)
        mockCoreData.deleteAddress(id: 1)
        addr = mockCoreData.getAddress()
        addrs = mockCoreData.getAddresses()
        XCTAssertEqual(addrs.count, 1)
        let hasAddr = mockCoreData.hasAddress()
        XCTAssertTrue(hasAddr)
        mockCoreData.deleteAddress()
        addrs = mockCoreData.getAddresses()
        expect.fulfill()
        XCTAssertEqual(addrs.count, 0)
        waitForExpectations(timeout: 5, handler: nil)
    }
    //
    //    func testFetchProduct() {
    //
    //        //Given
    //
    //       // var delegate = TestCoreDataStack()
    //        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
    //
    //
    //        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
    //            return true
    //        }
    //   //     let  coredDataRepo = CoreDataRepository(appDelegate: &delegate)
    ////
    //    //    expect.fulfill()
    //
    ////        product1.insert(into: context)
    ////        product2.insert(into: context)
    ////        product3.insert(into: context)
    //        let product = Product(id: 5, title: "test1", description: "", vendor: "", productType: "", images: [ProductImage(id: 0, productID: 5, position: 5, width: 20, height: 20, src: "", graphQlID: "")], options: nil, varients: nil)
    //       let product2 = Product(id: 58, title: "test1", description: "", vendor: "", productType: "", images: [ProductImage(id: 0, productID: 5, position: 5, width: 20, height: 20, src: "", graphQlID: "")], options: nil, varients: nil)
    //
    //   let managedContext = context
    //       //3
    //       let entity = NSEntityDescription.entity(forEntityName: "ProductCoreData", in: managedContext)
    //       //4
    //       let productCD = NSManagedObject(entity: entity!, insertInto: managedContext)
    //       productCD.setValue(product.varients?[0].id ?? 0, forKey: "id")
    //       productCD.setValue(product.count + 1, forKey: "count")
    //       productCD.setValue(product.varients?[0].price ?? "0.0", forKey: "price")
    //       productCD.setValue(product.title, forKey: "title")
    //       productCD.setValue(product.images[0].src, forKey: "imgUrl")
    //       do{
    //           try managedContext.save()
    //           print("product saved successfully in cart")
    //       }catch let error as NSError{
    //           print("error occured while saving product in cart \(error.localizedDescription)")
    //       }
    //
    ////        try! context.save()
    //        waitForExpectations(timeout: 2.0) { error in
    //            XCTAssertNil(error, "Save did not occur")
    //        }
    //        //When
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCoreData")
    ////
    //      //  fetchRequest.predicate = NSPredicate(format: "id == %@", product.id)
    //        let result = try? context.fetch(fetchRequest)
    //        let finalProduct1 = result?.first
    //        //Then
    //        XCTAssertEqual(result!.count, 1)
    ////        XCTAssertEqual(finalProduct1?.id, product.id)
    ////        XCTAssertEqual(finalProduct1?.name, product1.name)
    //    }
}

