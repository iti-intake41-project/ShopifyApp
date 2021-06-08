//
//  ShoppingBagViewModel.swift
//  ShopifyApp
//
//  Created by Moataz on 05/06/2021.
//

import Foundation

protocol addToShoppingCart {
    func addProduct(product: Product)
}

protocol ShoppingBagViewModelTemp: addToShoppingCart{
    func updateProductList(id: Int, product: Product)
    func getShoppingCartProductList()->[Product]
    func deleteProduct(id: Int)
}

protocol FavouriteViewModelTemp: addToShoppingCart{
    func isFavourite(id: Int)->Bool
    func deleteFavourite(id: Int)
    func addFavourite(product: Product)
    func getAllFaourites()->[Product]
    var favourites: [Product]{get}
    var bindFavouritesList:()->(){set get}
}

class ShoppingBagViewModel: ShoppingBagViewModelTemp {
    var bindFavouritesList: () -> () = {}
    
    var favourites: [Product]{
        didSet{
            bindFavouritesList()
        }
    }
    
    
    var delegate: AppDelegate
    let dataRepository: LocalDataRepository

    init(appDelegate: inout AppDelegate) {
        delegate = appDelegate
        dataRepository = CoreDataRepository(appDelegate: &delegate)
        favourites = dataRepository.getFavourites()
    }
    
    
    // MARK: - Shopping Cart
    func getShoppingCartProductList() -> [Product] {
        return dataRepository.getShoppingCartProductList()
    }
    
    func addProduct(product: Product) {
        let products = dataRepository.getShoppingCartProductList()
        for cartProduct in products{
            if product.id == cartProduct.id {
                return
            }
        }
        dataRepository.addProduct(product: product)
    }
    
    func updateProductList(id: Int, product: Product) {
        dataRepository.updateProductList(id: id, product: product)
    }
    
    func deleteProduct(id: Int) {
        dataRepository.deleteProduct(id: id)
    }

}


// MARK: - Favourites
extension ShoppingBagViewModel: FavouriteViewModelTemp {
    
    func isFavourite(id: Int)->Bool {
        var isFav = false
        let favourites = dataRepository.getFavourites()
        for favourite in favourites{
            if id == favourite.id{
                isFav = true
                break
            }
        }
        return isFav
    }
    
    func addFavourite(product: Product) {
        let products = dataRepository.getFavourites()
        for cartProduct in products{
            if product.id == cartProduct.id {
                return
            }
        }
        dataRepository.addFavourite(product: product)
        favourites = dataRepository.getFavourites()
    }
    
    func deleteFavourite(id: Int) {
        dataRepository.deleteFavourite(id: id)
        favourites = dataRepository.getFavourites()
    }
    
    func getAllFaourites() -> [Product] {
        return dataRepository.getFavourites()
    }
}
