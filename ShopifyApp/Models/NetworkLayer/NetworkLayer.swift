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
    //Donia
    func getDiscountCode(priceRuleID: String, completion: @escaping ([DiscountCode]?, Error?) -> ()) {
           AF.request(URLs.discountCodes(priceRuleID: priceRuleID)).validate().responseDecodable(of: DiscountCodes.self) { (response) in
                  
                  switch response.result {
                      case .success( _):
                              
                          guard let data = response.value else { return }
                          completion(data.discountCodes, nil)
                          
                      case .failure(let error):
                          
                          print(error)
                          completion(nil, error)
                  }
              }
          }

    //Donia

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
//    func getOrders(completion: @escaping (DataResponse<APIOrders, AFError>) -> ()){
//        AF.request(URLs.order()).validate().
//            }
//        }
//       }
    
    func addAddress(id: Int, address: Address, completion: @escaping(Data?, URLResponse?, Error?)->()){
        let id = id
        let customer = CustomerAddress(addresses: [address])
        let putObject = PutAddress(customer: customer)
        guard let url = URL(string: URLs.customer(id: "\(id)")) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: putObject.asDictionary(), options: .prettyPrinted)
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
    
    func editAddress(id: Int, address: Address, completion: @escaping(Data?, URLResponse?, Error?)->()){
        let id = id
        let putObject = UpdateAddress(address: address)
        
        guard let url = URL(string: URLs.addressUrl(customerId: id, addressId: address.id)) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: putObject.asDictionary(), options: .prettyPrinted)
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

    
    func deleteAddress(id: Int, completion: @escaping(Data?, URLResponse?, Error?)->()){
        let addressId = id
        let customerId = UserDefaultsLayer().getId()
        guard let url = URL(string: URLs.addressUrl(customerId: customerId, addressId: addressId)) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func deleteOrder(orderId: Int, completion: @escaping(Data?, URLResponse?, Error?)->()){
        guard let url = URL(string: URLs.deleteOrder(id: "\(orderId)")) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }




    //Moataz
    
    //Donia
     func getSmartCollections(completion: @escaping ([CustomCollections]?, Error?) -> ()) {
          AF.request(URLs.smartCollections()).validate().responseDecodable(of: SmartCollections.self) { (response) in
              
              switch response.result {
                  case .success( _):
                          
                      guard let data = response.value else { return }
                      completion(data.smartCollections, nil)
                      
                  case .failure(let error):
                      
                      print(error)
                      completion(nil, error)
              }
          }
      }
    //Donia
    func getAllProducts(completion: @escaping ([Product]?, Error?) -> ()) {
        AF.request(URLs.allProducts()).validate().responseDecodable(of: AllProducts.self) { (response) in
            
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
}
