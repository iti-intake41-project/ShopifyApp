//
//  ShopViewModel.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 5/22/21.
//

import Foundation

class ShopViewModel :NSObject{
    
    var networkService: NetworkLayer!
    var allProducts: AllProducts? {
        didSet {
            self.bindShopViewModelToView()
        }
    }
    var customCollections: ShopifyCollentions? {
        didSet {
            self.bindShopViewModelToView()
        }
    }
    var showError: String? {
        didSet {
            self.bindViewModelErrorToView()
        }
    }
    
    var bindShopViewModelToView : (()->()) = {}
    var bindViewModelErrorToView : (()->()) = {}
         
    override init() {
           
           super .init()
           self.networkService = NetworkLayer()
           self.fetchAllProductsFromAPI()
       }
   
       
    func fetchAllProductsFromAPI (collectionID: String = "268359598278"){
           
           networkService.fetchAllProducts(completion: { (allProducts, error) in
               
               if let error : Error = error{
                   
                   let message = error.localizedDescription
                   self.showError = message
                   
               }else{
                if let products = allProducts {
                   self.allProducts = products
                }
               }
              
           },collecionID: collectionID)
       }
    
    func fetchCustomCollection(){
        networkService.fetchCustomCollection(completion:{
             (customCollection , error) in
            if let error : Error = error{
                
                let message = error.localizedDescription
                self.showError = message
                
            }else{
             if let collections = customCollection {
                self.customCollections = collections
             }
            }
            
        })
    }
}
