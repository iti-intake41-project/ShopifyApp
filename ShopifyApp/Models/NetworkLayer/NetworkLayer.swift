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
    
    func getProducts(collectionID: String, completion: @escaping ([Product]?, Error?) -> ()) {
        AF.request(URLs.produts(collectionID: collectionID)).validate().responseDecodable(of: AllProducts.self) { (response) in
            
            switch response.result {
                case .success( _):
                        
                    guard let data = response.value else { return }
                    completion(data.products, nil)
                    
                case .failure(let error):
                    
                    print(error)
                    completion(nil, error)
            }
        }
    }
    
    
    //Moataz
    func login(email: String, password: String, completion: @escaping (DataResponse<LoginResponse, AFError>) -> ()){
        AF.request(URLs.customers()).validate().responseDecodable(of:LoginResponse.self) { (response) in
            completion(response)
        }
    }

    func registerCustomer(newCustomer:NewCustomer, completion:@escaping (Data?, URLResponse? , Error?)->()){
        guard let url = URL(string: URLs.customers()) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: newCustomer.asDictionary(), options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func postOrder(order: APIOrder, completion: @escaping (Data?, URLResponse?, Error?)->()){
        guard let url = URL(string: URLs.order()) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: order.asDictionary(), options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()

    }

    func getOrders(completion: @escaping (DataResponse<APIOrders, AFError>) -> ()){
        AF.request(URLs.order()).validate().responseDecodable(of:APIOrders.self) { (response) in
            completion(response)
        }
    }

    //Moataz
    
    
}
