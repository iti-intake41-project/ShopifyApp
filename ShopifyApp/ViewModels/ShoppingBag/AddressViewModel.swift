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
    func addAddress(country: String, city: String, address: String, zipcode: String)
    var message: String! {get}

}

class AddressViewModel: AddressViewModelTemp {
    
    var delegate: AppDelegate
    var dataRepository: LocalDataRepository
    var defaultsRepository = UserDefaultsLayer()
    var viewShowAlret:()->() = {
    }
    var navigateToCheckOut:()->() = {}
    
    var message: String!{
        didSet{
            self.viewShowAlret()
        }
    }
    
    init(appDelegate: inout AppDelegate) {
        delegate = appDelegate
        dataRepository = CoreDataRepository(appDelegate: &delegate)
    }
    
    func addAddress(country: String, city: String, address: String, zipcode: String){
        if country != ""{
            if city != ""{
                if address != ""{
                    let address = Address(address1: address, city: city, province: "", phone: "", zip: zipcode, last_name: "", first_name: "", country: country)
                    addAddress(address: address)
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
        addAddress(address: address) { [weak self] (data, response, error) in
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
                let id = returnedCustomer?["id"] as? Int ?? 0
                if id == 0 {
                    // failed to save address
                    self?.message = "An error occured while adding your address"
                }else {
                    //succeeded to save address
                    self?.navigateToCheckOut()
                    self?.dataRepository.addAddress(address: address)
                }
            }
        }
    }
    
    //Move to network layer
    func addAddress(address: Address, completion: @escaping(Data?, URLResponse?, Error?)->()){
        let customer = CustomerAddress(addresses: [address])
        let putObject = PutAddress(customer: customer)
        let id = defaultsRepository.getId()
        guard let url = URL(string: URLs.customer(id: "\(id)")) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: putObject.asDictionary(), options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}
