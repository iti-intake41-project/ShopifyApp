//
//  DiscountCodes.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/1/21.
//

import Foundation

struct DiscountCodes:Codable{
    let discountCodes:[DiscountCode]
    enum CodingKeys : String , CodingKey {
        case discountCodes = "discount_codes"
    }
}
struct DiscountCode:Codable {
    let id:Int
    let priceRuleId:Int
    let code:String
    let usageCount:Double?
    let createdAt:String?
    let updatedAt:String?
    
    enum CodingKeys : String , CodingKey {
            
            case id = "id"
            case priceRuleId = "price_rule_id"
            case code = "code"
            case usageCount = "usage_count"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
           

        }
      
}
