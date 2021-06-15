//
//  File.swift
//  ShopifyApp
//
//  Created by Moataz on 15/06/2021.
//

import Foundation

class ChooseAddressViewModel {
    let network = NetworkLayer()
    var delegate: AppDelegate
    var dataRepository: LocalDataRepository

    init(appDelegate: inout AppDelegate) {
        delegate = appDelegate
        dataRepository = CoreDataRepository(appDelegate: &delegate)
    }

    func getAddresses()->[Address]{
        return dataRepository.getAddresses()
    }
    
}
