//
//  AddressViewModel.swift
//  ShopifyApp
//
//  Created by Moataz on 10/06/2021.
//

import Foundation

protocol AddressViewModelTemp {
    var delegate: AppDelegate {get}
    var dataRepository: LocalDataRepository {get}
    var defaultsRepository: UserDefaultsLayer {get}
    var viewShowAlret:()->() {get set}
    var navigateToCheckOut:()->() {get set}
    func addAddress(country: String, city: String, address: String, phone: String)
    var message: String! {get}
    func editAddress(address: Address)

}

class AddressViewModel: AddressViewModelTemp {
    
    var delegate: AppDelegate
    var dataRepository: LocalDataRepository
    var defaultsRepository = UserDefaultsLayer()
    let network = NetworkLayer()
    var viewShowAlret:()->() = {
    }
    var navigateToCheckOut:()->() = {}
    
    var message: String!{
        didSet{
            self.viewShowAlret()
        }
    }
    
    init(appDelegate: AppDelegate) {
        delegate = appDelegate
        dataRepository = CoreDataRepository(appDelegate: &delegate)
    }
    
    func addAddress(country: String, city: String, address: String, phone: String){
        if country != ""{
            if city != ""{
                if address != ""{
                    var address = Address(address1: address, city: city, province: "", phone: phone, zip: "", last_name: "", first_name: "", country: country)
                    addAddress( address: address)
                }else{
                    message = "Please enter your address"
                }
            }else{
                message = "Please enter your city"
            }
        }else{
            message = "Please enter you country"
        }
    }
    
    func addAddress(address: Address){
        let id = defaultsRepository.getId()
        var newAddress = address
        network.addAddress(id: id, address: address) { [weak self] (data, response, error) in
            if error != nil {
                print("error while adding address \(error!)")
                self?.message = "An error occured while adding your address"
                //failed to save address
                return
            }
            if let data = data{
                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
                print("json: \(json)")
                let returnedCustomer = json["customer"] as? Dictionary<String,Any>
                do{
                    let reutrnedCust = try JSONDecoder().decode(NewCustomer.self, from: data)
                    print("***********")
                    print("result customer \(String(describing: reutrnedCust))")
                    print("***********")
                    print("new address id \(String(describing: reutrnedCust.customer.addresses?.last?.id ?? 0))")
                    print("***********")
                    newAddress.id = reutrnedCust.customer.addresses?.last?.id ?? 0
                }catch{
                    print("could parse response: \(error.localizedDescription)")
                }
                let id = returnedCustomer?["id"] as? Int ?? 0
//                let addresses = returnedCustomer?["addresses"] as? Int ?? 0
                if id == 0 {
                    // failed to save address
                    self?.message = "An error occured while adding your address"
                }else {
                    //succeeded to save address
                    self?.navigateToCheckOut()
                    
                    self?.dataRepository.addAddress(address: newAddress)
                }
            }
        }
    }
    
    func editAddress(address: Address){
        let id = defaultsRepository.getId()
        let editAddress = address
        network.editAddress(id: id, address: address) { [weak self] (data, response, error) in
            if error != nil {
                print("error while editing address \(error!)")
                self?.message = "An error occured while editing your address"
                //failed to save address
                return
            }
            if let data = data{
                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
                print("json: \(json)")
                let returnedCustomer = json["customer_address"] as? Dictionary<String,Any>
                let id = returnedCustomer?["id"] as? Int ?? 0
//                let addresses = returnedCustomer?["addresses"] as? Int ?? 0
                if id == 0 {
                    // failed to edit address
                    self?.message = "An error occured while editing your address"
                }else {
                    //succeeded to edit address
                    self?.navigateToCheckOut()
                    self?.dataRepository.editAddress(address: editAddress)
                }
            }
        }
    }

    
}
