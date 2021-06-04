//
//  LoginViewModel.swift
//  ShopifyApp
//
//  Created by Moataz on 03/06/2021.
//

import Foundation
import Alamofire

protocol LoginViewModelTemp {
    func login(email: String, password: String)
    var navigate:Bool!{get set}
    var notFound:Bool!{get set}
    var bindNavigate:(()->()) {get set}
    var bindDontNavigate:(()->()) {get set}
}

class LoginViewModel: LoginViewModelTemp {
    
    var navigate: Bool! {
        didSet{
            bindNavigate()
        }
    }
    var notFound: Bool!{
        didSet{
            bindDontNavigate()
        }
    }

    var bindNavigate:(()->()) = {}
    var bindDontNavigate:(()->()) = {}

    
    
    func login(email: String, password: String){
        let url = "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com/admin/api/2021-04/customers.json"
        AF.request(url).validate().responseDecodable(of:LoginResponse.self) { [weak self] (response) in
            switch response.result{
            case .success(_):
                guard let responseObject = response.value else {return}
                let customersList = responseObject.customers
                for customer in customersList {
                    let comingMail = customer.email ?? ""
                    let comingPassword = customer.tags ?? ""
                    if comingMail == email && comingPassword == password {
                        print("found")
                        self?.navigate = true
                        break
                    }
                }
                guard let _ = self?.navigate else{
                    self?.notFound = true
                    return
                }

            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
