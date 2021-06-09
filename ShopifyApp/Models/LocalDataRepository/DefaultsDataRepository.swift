//
//  DefaultsDataRepository.swift
//  ShopifyApp
//
//  Created by Moataz on 08/06/2021.
//

import Foundation

protocol DefaultsDataRepository {
    func isLoggedIn()->Bool
    func login()
    func logut()
    func hasAddress()->Bool
    func registerAddress()
    func unregisterAddress()
    func addId(id: Int)
    func getId()->Int
}

class UserDefaultsDataRepository: DefaultsDataRepository {
    
    func logut() {
        UserDefaults.standard.set(false, forKey: "IsLoggedIn")
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "IsLoggedIn")
    }
    
    func login() {
        UserDefaults.standard.set(true, forKey: "IsLoggedIn")
    }
    
    func hasAddress()->Bool {
        return UserDefaults.standard.bool(forKey: "Address")
    }
    
    func registerAddress() {
        UserDefaults.standard.set(true, forKey: "Address")
    }
    
    func unregisterAddress() {
        UserDefaults.standard.set(false, forKey: "Address")
    }
    
    func addId(id: Int) {
        UserDefaults.standard.set(id, forKey: "id")
    }
    func getId()->Int {
        return UserDefaults.standard.value(forKey: "id") as? Int ?? 0
    }

}
