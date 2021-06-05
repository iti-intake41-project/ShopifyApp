//
//  RegisterViewModel.swift
//  ShopifyApp
//
//  Created by Moataz on 03/06/2021.
//

import Foundation
import RxCocoa
import RxSwift


protocol RegisterViewModelTemp {
    var alertMsgDriver:Driver<String> {get}
    var alertMsgSubject:PublishSubject<String> {get}
    func registerCustomer(firstName:String, lastName:String,email:String,password:String,confirmPassword:String)
}

class RegisterViewModel: RegisterViewModelTemp {
    var alertMsgDriver:Driver<String>
    var alertMsgSubject = PublishSubject<String>()
    
    init() {
        alertMsgDriver = alertMsgSubject.asDriver(onErrorJustReturn: "")
    }
    
    
    func registerCustomer(firstName: String, lastName: String, email: String, password: String, confirmPassword: String) {
        if firstName != "" {
            if password == confirmPassword {
                if password.count >= 6 {
                    if isValidEmail(email){
                        
                        let customer = Customer(first_name: firstName, last_name: lastName, email: email, phone: nil, tags: password, id: nil, verified_email: true, addresses: nil)
                        let newCustomer = NewCustomer(customer: customer)
                        
                        //code to be moved to network layer
                        registerCustomer(newCustomer: newCustomer)
                        //*********************************
                        
                    }else{
                        //                    alertMsg = "Please enter a valid mail"
                        alertMsgSubject.onNext("Please enter a valid mail")
                    }
                }else{
                    alertMsgSubject.onNext("Password should be 6 characters at least")
                }
            }else{
                alertMsgSubject.onNext("Please check your password")
                //                alertMsg = "Please check your password"
            }
        }else{
            alertMsgSubject.onNext("Please insert your first name")
            //           alertMsg = "Please insert your first name"
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print("\(email) \(emailPred.evaluate(with: email))")
        return emailPred.evaluate(with: email)
    }
    
    
    //code to be moved to network layer
    func registerCustomer(newCustomer:NewCustomer){
        let urlString = "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com/admin/api/2021-04/customers.json"
        guard let url = URL(string: urlString) else {return}
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
        
        session.dataTask(with: request) {[weak self] (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let data = data {
                    let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
                    print("json: \(json)")
                    let returnedCustomer = json["customer"] as? Dictionary<String,Any>
                    let id = returnedCustomer?["id"] as? Int ?? 0
                    print("data: \(data)")
                    print("id: \(id)")
                    if id != 0 {
                        //registered successfully
                    }else{
                        self?.alertMsgSubject.onNext("An error occurred while registering")
                    }
                }
            }
        }.resume()
    }
    //*********************************
    
    
}




// MARK: - DataClasses
struct NewCustomer: Codable {
    let customer: Customer
}

// MARK: - Customer
struct Customer: Codable {
    let first_name, last_name, email, phone, tags: String?
    let id: Int?
    let verified_email: Bool?
    let addresses: [Address]?
}

// MARK: - Address
struct Address: Codable {
    let address, city, province, phone: String?
    let zip, last_name, first_name, country: String?
}
// MARK: - LoginResponse
struct LoginResponse: Codable {
    let customers: [Customer]
}


extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
