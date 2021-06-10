//
//  AddressViewModel.swift
//  ShopifyApp
//
//  Created by Moataz on 10/06/2021.
//

import Foundation

class AddressViewModel {
    
    var delegate: AppDelegate
    let dataRepository: LocalDataRepository
    let defaultsRepository = UserDefaultsDataRepository()
    var alretDidAppear:()->() = {}
    var message: String!{
        didSet{
            alretDidAppear()
        }
    }
    
    init(appDelegate: inout AppDelegate) {
        delegate = appDelegate
        dataRepository = CoreDataRepository(appDelegate: &delegate)
    }
    
    func addAddress(country: String, city: String, address: String, zipcode: String){
        
    }
    
}
