//
//  FormatePrice.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/9/21.
//

import Foundation
class FormatePrice {
    static func formatePrice(priceStr:String?) -> String {
           let settingViewModel = SettingViewModel()
           let currency  = settingViewModel.getCurrency(key: "currency")
           if  currency == "EGP" {
           return "EGP \(toEGP(amount:Double(priceStr ?? "")! ))"
           }
           else {
               return "USD \(priceStr!)"
               
           }
       }
     static  func toEGP(amount:Double) -> Double {
            
           return Double(round(100*(amount * 15.669931))/100)
       }
}
