//
//  ShopViewModel.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 5/22/21.
//

import Foundation

class ShopViewModel :NSObject{
    
    var networkService = NetworkLayer()
    
    var allProducts: [Product]? {
        didSet {
            self.bindProductsViewModelToView()
        }
    }
    var customCollections: [CustomCollections]? {
        didSet {
            self.bindCollectionsViewModelToView()
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
    
    var bindProductsViewModelToView : (()->()) = {}
    var bindCollectionsViewModelToView : (()->()) = {}
    var bindAddsViewModelToView : (()->()) = {}

    var bindViewModelErrorToView : (()->()) = {}
    
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
    
    func fetchAdds (priceRuleID: String = "950161080518"){

        networkService.getDiscountCode(priceRuleID: priceRuleID){ (adds , error) in
            if let error : Error = error{

                let message = error.localizedDescription
                self.showError = message

            }else{
                if let adds = adds {
                    self.adds = adds
                }
            }
    }
}
}
