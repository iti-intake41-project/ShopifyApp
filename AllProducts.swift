//
//  AllProducts.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 5/22/21.
//

import Foundation


struct AllProducts:Codable{
    let products:[Product]
    enum CodingKeys : String , CodingKey {
        case products = "products"
    }
}
struct Product:Codable {
    let id:Int
    let title:String
    let description:String
    let vendor:String?
    let productType:String?
    let images:[ProductImage]
    let options:[OptionList]?
    let varients:[Varient]?
    
    enum CodingKeys : String , CodingKey {
            
            case id = "id"
            case title = "title"
            case description = "body_html"
            case vendor = "vendor"
            case productType = "product_type"
            case images = "images"
            case options = "options"
            case varients = "variants"

        }
      
    
}
struct ProductImage:Codable {
    let id:Int
    let productID:Int
    let position:Int
    let width:Double
    let height:Double
    let src:String
    let graphQlID:String
    
   enum CodingKeys : String , CodingKey {
          
          case id = "id"
          case productID = "product_id"
          case position = "position"
          case width = "width"
          case height = "height"
          case src = "src"
          case graphQlID = "admin_graphql_api_id"

      }
    
}
struct OptionList:Codable{
    
    let id:Int
    let productID :Int
    let name:String
    let position:Int
    let values:[String]?
    
    enum CodingKeys : String , CodingKey {
          
          case id = "id"
          case productID = "product_id"
          case name = "name"
          case position = "position"
          case values = "values"
          
      }
    

}
struct Varient:Codable {
    let id:Int
    let productID:Int
    let title:String
    let price :String
    
    enum CodingKeys : String , CodingKey {
            
            case id = "id"
            case productID = "product_id"
            case title = "title"
            case price = "price"
            
        }
}
