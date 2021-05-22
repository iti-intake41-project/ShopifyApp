//
//  ShopifyCollentions.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 5/22/21.
//

import Foundation
 
struct ShopifyCollentions : Codable{
    let customCollections:[CustomCollections]
}

struct CustomCollections :Codable{
    let id:Int
    let title: String
    let image: Image?
    
    enum CodingKeys : String , CodingKey {
             
             case id = "id"
             case title = "title"
             case image = "image"
        
         }
       
}

struct Image :Codable {
    let width:Double
    let height:Double
    let src:String
    
    enum CodingKeys : String , CodingKey {
               
               case width = "width"
               case height = "height"
               case src = "src"
          
           }
}
