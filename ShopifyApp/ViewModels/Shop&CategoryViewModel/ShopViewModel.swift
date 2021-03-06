//
//  ShopViewModel.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 5/22/21.
//

import Foundation
class ShopViewModel :NSObject{
    
    var networkService = NetworkLayer()
    var userDefaults  = UserDefaultsLayer ()
    var bindShopViewModelToView : (()->()) = {}
    var bindCategoryViewModelToView : (()->()) = {}
    var bindViewModelErrorToView : (()->()) = {}
    var bindAddsViewModelToView : (()->()) = {}

    var bindsmartCollectionsViewModelToView : (()->()) = {}
    
    var allProducts: [Product]? {
        didSet {
            self.bindShopViewModelToView()
        }
    }
    var customCollections: [CustomCollections]? {
        didSet {
            self.bindCategoryViewModelToView()
        }
    }
    var smartCollections: [CustomCollections]? {
           didSet {
               self.bindsmartCollectionsViewModelToView()
           }
       }

    var adds: [DiscountCode]? {
        didSet {
            self.bindAddsViewModelToView()
        }
    }
    var showError: String? {
        didSet {
            self.bindViewModelErrorToView()
        }
    }
    
    
    override init() {
        super .init()
        //self.fetchAllProductsFromAPI()
    }
    
    
    func fetchAllProductsFromAPI (collectionID: String = "268359598278"){
        
        networkService.getProducts(collectionID: collectionID) { (product, error) in
            if let error : Error = error{
                
                let message = error.localizedDescription
                self.showError = message
                
            }else{
                if let products = product {
                    self.allProducts = products
                }
            }
        }
    }
    
    func fetchCustomCollection(){
        networkService.getCategories { (customCollections, error) in
            if let error : Error = error{
                
                let message = error.localizedDescription
                self.showError = message
                
            }else{
                if let collections = customCollections {
                    self.customCollections = collections
                }
            }
        }
    }
    func fetchSmartCollection(){
           networkService.getSmartCollections { (smartCollections, error) in
               if let error : Error = error{
                   
                   let message = error.localizedDescription
                   self.showError = message
                   
               }else{
                   if let collections = smartCollections {
                       self.smartCollections = collections
                   }
               }
           }
       }
    func searchProduct(sProducts:[CustomCollections],searchTxt:String)
        ->[CustomCollections]{
            return searchTxt.isEmpty ? sProducts : sProducts.filter({
                (data :CustomCollections)->Bool in
                print ("search done ")
                //                  return data.varients?[0].price.range(of: searchTxt , options: .caseInsensitive) != nil
                //
                return data.title.range(of: searchTxt , options: .caseInsensitive) != nil
                
            })
    }
    func fetchAdds (priceRuleID: String = "950161080518"){
        
        networkService.getDiscountCode(priceRuleID: priceRuleID){ (adds , error) in
            if let error : Error = error{
                
                let message = error.localizedDescription
                self.showError = message
                
            }else{
                if let adds = adds {
                    self.adds = adds
                    print("discount code: \(adds[0].code)")
                    self.userDefaults.setDiscountCode(code: adds[0].code)
                }
            }
        }
    }
    func isLoggedIn() -> Bool {
           return userDefaults.isLoggedIn()
       }
    
}
