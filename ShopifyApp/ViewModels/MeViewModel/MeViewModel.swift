//
//  MeViewModel.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 5/12/21.
//

import Foundation
import UIKit
class MeViewModel{
    let network = NetworkLayer()
    let defaultsRepository = UserDefaultsLayer()
    
    func getOrders()-> [Product]?{
        //call orders from network layer
        return[]
    }
    
    //get orders
    func getOrders()->[Order]{
        let customerId = defaultsRepository.getId()
        var orders: [Order] = []
        network.getOrders { (response) in
            
            switch response.result{
            
            case .success(let result):
//                print("result: \(result)")
                let APIOrders = result.orders
                for order in APIOrders{
                    if order.customer.id == customerId {
                        print("matching order: \(order)")
                        orders.append(order)
                    }
                }
                
            case .failure(let error):
                print("error while getting orders: \(error.localizedDescription)")
            }
            
        }
        return orders
    }

    
    //wishList
    func getfavourites(appDelegate: inout AppDelegate) ->[Product]{
        var viewModel:FavouriteViewModelTemp!
        viewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        return viewModel.getAllFaourites()
        
    }
    func isLoggedIn(
        userLbl:UILabel,
        loginOrRegisterOrderStackView:UIStackView,
        loginOrRegisterFavStackView:UIStackView ,
        orderStackView:UIStackView,
        favouriteStackView:UIStackView) -> Bool{
        
        let settingViewModel = SettingViewModel()
        var isLogegedIn = false
        isLogegedIn = settingViewModel.isLoggedIn()
        print(isLogegedIn)
        if isLogegedIn {
            loginOrRegisterOrderStackView.isHidden = true
            loginOrRegisterFavStackView.isHidden = true
            orderStackView.isHidden = false
            favouriteStackView.isHidden = false
            userLbl.text = "Welcome \(defaultsRepository.getUserName())"
            return true
            
        }else{
            loginOrRegisterOrderStackView.isHidden = false
            loginOrRegisterFavStackView.isHidden = false
            userLbl.isHidden = true
            orderStackView.isHidden = true
            favouriteStackView.isHidden = true
            return false
            
        }
    }
    
}
