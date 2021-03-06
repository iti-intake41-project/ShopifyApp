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
//    var orderItems = [OrderItem]()
    var orders:[Order]!{
        didSet{
            self.bindOrders()
        }
    }
    
    var bindOrders:()->() = {}
    
    //get orders
    func getOrders() {
        let customerId = defaultsRepository.getId()
        var comingOrder: [Order] = []
//        orderItems = []
        network.getOrders { (response) in
            
            switch response.result{
            
            case .success(let result):
            //   print("result: \(result)")
                let APIOrders = result.orders
                for order in APIOrders{
                    if order.customer.id == customerId {
                 //       print("matching order: \(order)")
                        comingOrder.append(order)
                    }
                }
//                for order in comingOrder {
//                    for orderItem in order.line_items {
//                        self.orderItems.append(orderItem)
//                //        print("in for \(orderItem.price)")
//                    }
//
//                }
               print("orders count \(comingOrder.count)")
                print("orders count \(self.orders?.count)")
                
                if comingOrder.count > 0{
                    print("set order list")
                        self.orders = comingOrder

                }
                
            case .failure(let error):
                print("error while getting orders: \(error.localizedDescription)")
            }
            
        }
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
 
    func deleteOrder(orderId: Int){
        network.deleteOrder(orderId: orderId) { [weak self] (data, response, error) in
            let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String,Any>
            if json.isEmpty {
                print("deleted")
            }else{
                print("cant delete")
            }
            print(json)
        }
    }
}
