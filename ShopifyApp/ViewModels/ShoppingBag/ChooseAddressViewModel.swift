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
    var reloadTable: ()->() = {}

    init(appDelegate: inout AppDelegate) {
        delegate = appDelegate
        dataRepository = CoreDataRepository(appDelegate: &delegate)
    }

    func getAddresses()->[Address]{
        return dataRepository.getAddresses()
    }
    
    func deleteAddress(addressId: Int){
        NetworkLayer().deleteAddress(id: addressId) { [weak self] (data, response, error) in
            let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String,Any>
            if json.isEmpty {
                print("deleted")
                //delete address from coreData
                self?.dataRepository.deleteAddress(id: addressId)
                self?.reloadTable()
            }else{
                print("cant delete")
            }
            print(json)
        }
    }
    
}
