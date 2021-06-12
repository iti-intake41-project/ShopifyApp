//
//  MeViewModel.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 5/12/21.
//

import Foundation
import UIKit
class MeViewModel{
    
    
    func getOrders()-> [Product]?{
        //call orders from network layer
        return[]
    }
    //wishList
    func getfavourites(appDelegate: inout AppDelegate) ->[Product]{
        var viewModel:FavouriteViewModelTemp!
        viewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        return viewModel.getAllFaourites()
        
    }
    func isLoggedIn(
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
            return true
            
        }else{
            loginOrRegisterOrderStackView.isHidden = false
            loginOrRegisterFavStackView.isHidden = false
            orderStackView.isHidden = true
            favouriteStackView.isHidden = true
            return false
            
        }
    }
    
}
