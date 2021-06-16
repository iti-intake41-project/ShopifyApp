//
//  URLs.swift
//  ShopifyApp
//
//  Created by Abanob Wadie on 19/05/2021.
//

import Foundation

class URLs {
    private static var baseUrl = "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com/admin/api/2021-04/"
    
    static func categories() -> String {
        return baseUrl + "custom_collections.json"
    }
    
    static func produts(collectionID: String) -> String {
        return baseUrl + "products.json?collection_id=\(collectionID)"
    }
    
    static func customers() -> String {
        return baseUrl + "customers.json"
    }
    
    static func customer(id: String) -> String {
        return baseUrl + "customers/\(id).json"
    }
    
    static func order()->String{
        return baseUrl + "orders.json"
    }

    static func discountCodes(priceRuleID: String) -> String {
              return baseUrl + "price_rules/950161080518/discount_codes.json"
          }
    static func deleteAddress(customerId: Int, addressId: Int) -> String {
        return baseUrl + "customers/\(customerId)/addresses/\(addressId).json"
    }
    //Donia
    static func smartCollections() -> String {
        return baseUrl + "smart_collections.json"
    }
    //Donia
    
}
