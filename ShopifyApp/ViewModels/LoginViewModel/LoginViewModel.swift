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
    var alertMessage: String! {get}
}

class LoginViewModel: LoginViewModelTemp {
    
    let defaultsRepo: DefaultsDataRepository = UserDefaultsDataRepository()
    let dataRepository: LocalDataRepository

    init(appDelegate: inout AppDelegate) {
        dataRepository = CoreDataRepository(appDelegate: &appDelegate)
//        defaultsRepo.logut()
        print("is logged in? \(defaultsRepo.isLoggedIn())")
        print("has address? \(dataRepository.hasAddress())")
        print("address: \(dataRepository.getAddress())")
    }

    var alertMessage: String!{
        didSet{
            bindDontNavigate()
        }
    }
    
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
        if isValidEmail(email){
            if password.count >= 6{
                AF.request(URLs.customers()).validate().responseDecodable(of:LoginResponse.self) { [weak self] (response) in
                    switch response.result{
                    case .success(_):
                        guard let responseObject = response.value else {return}
                        let customersList = responseObject.customers
                        for customer in customersList {
                            let comingMail = customer.email ?? ""
                            let comingPassword = customer.tags ?? ""
                            if comingMail == email && comingPassword == password {
                                print("correct customer address: \(customer.addresses?[0].address1 != "")")
                                print("found")
                                self?.defaultsRepo.login()
                                self?.defaultsRepo.addId(id: customer.id ?? 0)
                                if customer.addresses?[0].address1 != "" {
                                    //save address
                                    self?.dataRepository.addAddress(address: customer.addresses![0])
//                                    self?.defaultsRepo.addAddressFlag()
                                }
                                self?.navigate = true
                                break
                            }
                        }
                        guard let _ = self?.navigate else{
                            self?.notFound = true
                            self?.alertMessage = "Can't login, please check your info"
                            return
                        }

                    case .failure(let error):
                        self?.alertMessage = "An error occured while logging-in, please try again later"
                        print(error)
                    }
                }
            } else{
                alertMessage = "Password should be 6 characters at least"
            }
        }else{
            alertMessage = "Please enter a valid mail"
        }
    }

}
