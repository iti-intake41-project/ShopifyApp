//
//  TestAddressViewModels.swift
//  ShopifyAppTests1
//
//  Created by Donia Ashraf on 6/19/21.
//

import XCTest
@testable import ShopifyApp

class TestAddressViewModels: XCTestCase {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var addressVM :AddressViewModel!
    var chooseAddrVM: ChooseAddressViewModel!
    var showAddrVM: ShowAddressViewModel!
    var addr1:Address!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        addressVM = AddressViewModel(appDelegate: appDelegate)
        chooseAddrVM = ChooseAddressViewModel(appDelegate: &appDelegate)
        showAddrVM = ShowAddressViewModel(delegate: &appDelegate)
        addr1 = Address(address1: "123", city: "suez", province: "", phone: "", zip: "", last_name: "", first_name: "Donia", country: "Egypt", id: 1)
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
    func testAddr(){
        addressVM.addAddress(address: addr1)
        addressVM.addAddress(country: "Egypt", city: "suez", address: "10", zipcode: "")
    }

    func testShowAddr(){
       // let expect = expectation(description: "expect")
        testAddr()
        showAddrVM.getAddresses()
        showAddrVM.showAddresses = {
            guard let addrss = self.showAddrVM.addresses else {
                return
            }
            XCTAssertTrue(addrss.count > 0)
        }
        addressVM.addAddress(address: addr1)

        showAddrVM.deleteAddress(addressId: 1)
        showAddrVM.showAddresses = {
                   guard let addrss = self.showAddrVM.addresses else {
                       return
                   }
                   XCTAssertTrue(addrss.count > 0)

               }

    }
    func testChooseAdd(){
        
        var addrs = chooseAddrVM.getAddresses()
//        XCTAssertEqual(addrs.count, 1)
        XCTAssertEqual(addrs.count, 1)

        chooseAddrVM.deleteAddress(addressId: 6482696863942)
        addrs = chooseAddrVM.getAddresses()
      //  XCTAssertEqual(addrs.count, 0)
        
    }
}
