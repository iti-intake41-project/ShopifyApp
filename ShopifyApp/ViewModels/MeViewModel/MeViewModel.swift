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
    var orderItems = [OrderItem]()
    var orders = [Order]()
    
    var updateOrders:()->() = {
        
    }
    var bindOrders:()->() = {
           
       }
//    func getOrders()-> [Product]?{
//        //call orders from network layer
//        return[]
//    }
    
    //get orders
    func getOrders()->[Order] {
        let customerId = defaultsRepository.getId()
        var orders: [Order] = []
        orderItems = []
        network.getOrders { (response) in
            
            switch response.result{
            
            case .success(let result):
            //   print("result: \(result)")
                let APIOrders = result.orders
                
                self.orders = result.orders
                for order in APIOrders{
                    if order.customer.id == customerId {
                 //       print("matching order: \(order)")
                        orders.append(order)
                    }
                }
                for order in orders {
                    for orderItem in order.line_items {
                        self.orderItems.append(orderItem)
                //        print("in for \(orderItem.price)")
                    }
                    
                }
                self.updateOrders()
                self.bindOrders()
               print("orders count \(orders.count)")
                print("orders count \(self.orders.count)")

                
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
     func isLoggedIn() -> Bool{
          
          let settingViewModel = SettingViewModel()
          var isLogegedIn = false
          isLogegedIn = settingViewModel.isLoggedIn()
          print(isLogegedIn)
          if isLogegedIn {
              return true
              
          }else{
              return false
              
          }
      }
      func getUserName() -> String {
         return defaultsRepository.getUserName()

      }
 
    
}
