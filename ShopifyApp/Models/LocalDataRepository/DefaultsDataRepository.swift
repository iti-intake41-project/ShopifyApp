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
    
}
