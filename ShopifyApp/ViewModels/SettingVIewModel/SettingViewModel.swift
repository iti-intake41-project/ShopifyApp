//
//  SettingViewModel.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/9/21.
//

import Foundation

class SettingViewModel :NSObject{
    
    var userDefaults  = UserDefaultsLayer ()
    var bindSettingViewModel : (()->()) = {}
    
    var currency: String?{
        didSet {
//            print("from didSelect :\(currency!) ")
            self.bindSettingViewModel()
        }
    }
    
    override init() {
        
        super .init()
        currency = getCurrency(key: "currency")
        
    }
    
    
    func getCurrency (key:String)->String{
        self.currency = userDefaults.getCurrency(key: key)
        return self.currency!
        
    }
    func setCurrency(key:String , value:String){
        userDefaults.setCurrency(key: key, value: value)
        self.currency = value

    }
    
    //moataz
    func logout(appDelegate:inout AppDelegate){
        userDefaults.logut()
        CoreDataRepository.deleteAddress(appDelegate: &appDelegate)
    }
    //Moataz
}
