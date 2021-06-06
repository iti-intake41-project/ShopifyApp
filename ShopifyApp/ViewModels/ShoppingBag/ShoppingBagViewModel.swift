//
//  ShoppingBagViewModel.swift
//  ShopifyApp
//
//  Created by Moataz on 05/06/2021.
//

import Foundation


protocol ShoppingBagViewModelTemp{
    func updateProductList(id: Int, product: Product)
    func addProduct(product: Product)
    func getProductList()->[Product]
    func deleteProduct(id: Int)
}

class ShoppingBagViewModel: ShoppingBagViewModelTemp {
    
    var delegate: AppDelegate
    let dataRepository: LocalDataRepository

    init(appDelegate: inout AppDelegate) {
        delegate = appDelegate
        dataRepository = RealmDataRepository(appDelegate: &delegate)
    }
    
    func getProductList() -> [Product] {
        return dataRepository.getProductList()
    }
    
    func addProduct(product: Product) {
        dataRepository.addProduct(product: product)
    }
    
    func updateProductList(id: Int, product: Product) {
        dataRepository.updateProductList(id: id, product: product)
    }
    
    func deleteProduct(id: Int) {
        dataRepository.deleteProduct(id: id)
    }

}
