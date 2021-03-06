//
//  ShoppingBagViewModel.swift
//  ShopifyApp
//
//  Created by Moataz on 05/06/2021.
//

import Foundation
import Alamofire

protocol baseProtocol {
    func addProduct(product: Product)
}

protocol ShoppingBagViewModelTemp: baseProtocol {
    func updateProductList(id: Int, product: Product)
    func getShoppingCartProductList()->[Product]
    func deleteProduct(id: Int)
    func navigateToCheckOut()
    var navigateToAddress:()->(){set get}
    var navigateToPayment:()->(){set get}
    func getCurrency()->String
    func postOrder(products: inout [Product])
    func deleteFavourite(id: Int)
    func addFavourite(product: Product)
    func isFavourite(id: Int)->Bool
}

protocol FavouriteViewModelTemp: baseProtocol {
    func isFavourite(id: Int)->Bool
    func deleteFavourite(id: Int)
    func addFavourite(product: Product)
    func getAllFaourites()->[Product]
    var favourites: [Product]{get}
    var bindFavouritesList:()->(){set get}
}

class ShoppingBagViewModel: ShoppingBagViewModelTemp {
    var navigateToAddress = {}
    var navigateToPayment = {}

    var bindFavouritesList: () -> () = {}
    var favourites: [Product]{
        didSet{
            bindFavouritesList()
        }
    }
    
    let network = NetworkLayer()
    var delegate: AppDelegate
    let dataRepository: LocalDataRepository
    let defaultsRepository = UserDefaultsLayer()
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
            if product.varients?[0].id ?? 0 == cartProduct.varients?[0].id ?? 0 {
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
    
    func navigateToCheckOut() {
//        navigateToAddress()
        if dataRepository.hasAddress() {
            navigateToPayment()
        } else {
            navigateToAddress()
        }
    }
    
    func getCurrency()->String{
        return defaultsRepository.getCurrency()
    }
    
    //MARK: - abanob
    func isInShopingCart(id: Int)->Bool {
        var isIn = false
        let products = dataRepository.getShoppingCartProductList()
        for product in products{
            if id == product.id{
                isIn = true
                break
            }
        }
        return isIn
    }
    
    // MARK: - Order
    func postOrder(products: inout [Product]){
        var items: [OrderItem] = []
        for product in products{
            items.append(OrderItem(variant_id: product.varients?[0].id ?? 0, quantity: product.count, price: product.varients?[0].price ?? "0.0"))
        }
        let customer = OrderCustomer(id: defaultsRepository.getId())
        let order = Order(line_items: items, customer: customer)
        let myOrder = APIOrder(order: order)
//        print("my order: \(myOrder)")
        network.postOrder(order: myOrder) {[weak self] (data, response, error) in
            if error != nil{
                print("error while posting order \(error!.localizedDescription)")
            }
            if let data = data{
                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
//                print("json: \(json)")
                let returnedOrder = json["order"] as? Dictionary<String,Any>
                let returnedCustomer = returnedOrder?["customer"] as? Dictionary<String,Any>
                let id = returnedCustomer?["id"] as? Int ?? 0
//                print("customer id: \(id)")
                if id != 0 {
                    print("call empty cart")
                    self?.dataRepository.emptyCart()
                }
            }
        }
    }
    
    
}


// MARK: - Favourites
extension ShoppingBagViewModel: FavouriteViewModelTemp {
    
    func isFavourite(id: Int)->Bool {
        print("is favourite viewmodel: \(id)")

        var isFav = false
        let favourites = dataRepository.getFavourites()
        for favourite in favourites{
            if id == favourite.varients?[0].id{
                print("is favourite viewmodel loop: \(favourite.varients?[0].id ?? 0)")

                isFav = true
                break
            }
        }
        return isFav
    }
    
    func addFavourite(product: Product) {
//        let products = dataRepository.getFavourites()
//        for favProduct in products{
//            if product.varients?[0].id == favProduct.varients?[0].id {
//                print("product id: \(product.varients?[0].id) fav id: \(favProduct.varients?[0].id)")
//                return
//            }
//        }
        dataRepository.addFavourite(product: product)
        favourites = dataRepository.getFavourites()
    }
    
    func deleteFavourite(id: Int) {
        dataRepository.deleteFavourite(id: id)
        favourites = dataRepository.getFavourites()
    }
    
    func getAllFaourites() -> [Product] {
        favourites = dataRepository.getFavourites()
        return dataRepository.getFavourites()
    }
    
}
