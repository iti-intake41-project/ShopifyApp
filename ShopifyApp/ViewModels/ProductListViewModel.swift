//
//  ProductListViewModel.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/2/21.
//

import Foundation

class ProductListViewModel :NSObject{
    
    var networkService = NetworkLayer()
    
    var allProducts: [Product]? {
        didSet {
            self.bindProductListViewModelToView()
        }
    }

    var showError: String? {
        didSet {
            self.bindViewModelErrorToView()
        }
    }
    
    var bindProductListViewModelToView : (()->()) = {}
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
    func searchProduct(sProducts:[Product],searchTxt:String)
        ->[Product]{
       return searchTxt.isEmpty ? sProducts : sProducts.filter({
                  (data :Product)->Bool in
                   print ("search done ")
                  return data.varients?[0].price.range(of: searchTxt , options: .caseInsensitive) != nil
               
              })
        
    }
    
   
}
