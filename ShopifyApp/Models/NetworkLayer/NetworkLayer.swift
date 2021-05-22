//
//  NetworkLayer.swift
//  ShopifyApp
//
//  Created by Abanob Wadie on 19/05/2021.
//

import Foundation
import Alamofire

class NetworkLayer {
    
    
    func getCategories(completion: @escaping ([CustomCollections]?, Error?) -> ()) {
        AF.request(URLs.categories()).validate().responseDecodable(of: ShopifyCollentions.self) { (response) in
            
            switch response.result {
                case .success( _):
                        
                    guard let data = response.value else { return }
                    completion(data.customCollections, nil)
                    
                case .failure(let error):
                    
                    print(error)
                    completion(nil, error)
            }
        }
    }
    
    
}
