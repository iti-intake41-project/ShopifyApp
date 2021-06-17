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
    var logout: Bool?{
        didSet {
            //            print("from didSelect :\(currency!) ")
            self.bindSettingViewModel()
        }
    }
    var address: Address?{
          didSet {
              //            print("from didSelect :\(currency!) ")
              self.bindSettingViewModel()
          }
      }
    override init() {
        
        super .init()
        currency = getCurrency(key: "currency")
        
    }
    func getAddress(appDelegate:inout AppDelegate) -> Address {
        let coreDataRepo = CoreDataRepository(appDelegate:&appDelegate)
        address = coreDataRepo.getAddress()
        return coreDataRepo.getAddress()
    }
    func hasAddress(appDelegate:inout AppDelegate) -> Bool {
         let coreDataRepo = CoreDataRepository(appDelegate:&appDelegate)
               
               return coreDataRepo.hasAddress()
    }
    
    func getCurrency (key:String)->String{
        self.currency = userDefaults.getCurrency(key: key)
        return self.currency!
        
    }
    func setCurrency(key:String , value:String){
        userDefaults.setCurrency(key: key, value: value)
        self.currency = value
        
    }
    func isLoggedIn() -> Bool {
        print()
        logout = userDefaults.isLoggedIn()
        return userDefaults.isLoggedIn()
    }
    
    //moataz
    func logout(appDelegate:inout AppDelegate){
        //donia
        userDefaults.setCurrency(key: "currency", value:"")
        userDefaults.addUserName(userName: "")
        self.logout = false
        //donia
        
        //remove address, empty fav & cart, switch flag
        userDefaults.logut()
        userDefaults.addId(id: 0)
        let dataRepo = CoreDataRepository(appDelegate: &appDelegate)
        dataRepo.deleteAddress()
        let favourites = dataRepo.getFavourites()
        for product in favourites{
            dataRepo.deleteFavourite(id: product.varients?[0].id ?? 0)
        }
        dataRepo.emptyCart()
    }
    //Moataz
}
