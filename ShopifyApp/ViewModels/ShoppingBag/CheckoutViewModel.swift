//
//  checkoutViewModel.swift
//  ShopifyApp
//
//  Created by Moataz on 16/06/2021.
//

import Foundation

class CheckoutViewModel {
    let defaults = UserDefaultsLayer()
    let network = NetworkLayer()
    var dataRepository: LocalDataRepository

    init(appDelegate: inout AppDelegate) {
        var delegate = appDelegate
        dataRepository = CoreDataRepository(appDelegate: &delegate)
    }
    
    func getCurrency()->String{
        return defaults.getCurrency()
    }
    
    func checkCoupon(coupon: String)->Bool{
        print("discount code: \(defaults.getDiscountCode())")
        return coupon.elementsEqual(defaults.getDiscountCode()) && coupon != ""
    }
    
    func postOrder(products: inout [Product]){
        print("post order view model")
        var items: [OrderItem] = []
        for product in products{
            items.append(OrderItem(variant_id: product.varients?[0].id ?? 0, quantity: product.count, price: product.varients?[0].price ?? "0.0"))
        }
        let customer = OrderCustomer(id: defaults.getId())
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
                print("call empty cart")

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
