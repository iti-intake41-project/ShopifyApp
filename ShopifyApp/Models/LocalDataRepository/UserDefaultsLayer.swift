//
//  UserDefaultsLayer.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/9/21.
//

import Foundation

protocol UserDefaultsData{
    func getCurrency(key:String) -> String
    func setCurrency(key:String , value:String)
    func getAddress(key:String)-> String
    func setAddress(key:String , value:String)
    func getUserStatus()->Bool
    func setUserStatus(status:Bool)

}
class UserDefaultsLayer: UserDefaultsData {
    
    let defaults = UserDefaults.standard

    func getUserStatus() -> Bool {
        return true
    }
    
    func setUserStatus(status: Bool) {
        
    }
    
    func getCurrency(key: String) -> String {

        return self.defaults.string(forKey: key) ?? "empty currency"
    }
    
    func setCurrency(key: String, value: String) {
        print(value)
        self.defaults.set(value, forKey: key)

    }
    
    func getAddress(key: String) -> String {
        return ""
    }
    
    func setAddress(key: String, value: String) {
        
    }
    
    
    
}
