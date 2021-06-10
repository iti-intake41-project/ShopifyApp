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
    func getUserStatus()->Bool
    func setUserStatus(status:Bool)
    //Moataz
    func isLoggedIn()->Bool
    func login()
    func logut()
    func addId(id: Int)
    func getId()->Int
    //Moataz
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
    
    //Moataz
    func logut() {
        UserDefaults.standard.set(false, forKey: "IsLoggedIn")
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "IsLoggedIn")
    }
    
    func login() {
        UserDefaults.standard.set(true, forKey: "IsLoggedIn")
    }
    
    func addId(id: Int) {
        UserDefaults.standard.set(id, forKey: "id")
    }
    func getId()->Int {
        return UserDefaults.standard.value(forKey: "id") as? Int ?? 0
    }
    //Moataz
    
    
}
