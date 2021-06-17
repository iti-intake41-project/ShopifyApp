//
//  ShowAddressViewModel.swift
//  ShopifyApp
//
//  Created by Moataz on 17/06/2021.
//

import Foundation

class ShowAddressViewModel {
    let coreDataRepo: CoreDataRepository
    let network = NetworkLayer()
    var showAddresses:()->()={}
    var cantDeleteAddress:()->() = {}
    var addresses:[Address]!{
        didSet{
            showAddresses()
        }
    }
    
    init(delegate:inout AppDelegate) {
        coreDataRepo = CoreDataRepository(appDelegate: &delegate)
    }
    
    func getAddresses()/*->[Address]*/{
        addresses = coreDataRepo.getAddresses()
//        return coreDataRepo.getAddresses()
    }
    
//    func deleteAddress(id: Int){
//        coreDataRepo.deleteAddress(id: id)
//        network.deleteAddress(id: id) { (data, response, error) in
//            print("delete address")
//        }
//    }
    
    func deleteAddress(addressId: Int){
        network.deleteAddress(id: addressId) { [weak self] (data, response, error) in
            let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String,Any>
            if json.isEmpty {
                print("deleted")
                //delete address from coreData
                self?.coreDataRepo.deleteAddress(id: addressId)
                self?.addresses = self?.coreDataRepo.getAddresses()
//                self?.reloadTable()
            }else{
                print("cant delete")
                self?.cantDeleteAddress()
            }
            print(json)
        }
    }

    
}
