//
//  LoginTableViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 04/06/2021.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginTableViewController: UITableViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var viewModel: LoginViewModelTemp = LoginViewModel()
    var email, password: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        GIDSignIn.sharedInstance()?.presentingViewController = self

    }
    
    func bindToViewModel(){
        viewModel.bindNavigate = { [weak self] in
            self?.navigate()
        }
        
        viewModel.bindDontNavigate = { [weak self] in
            self?.showAlret(message: "Can't login, please check your info")
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        email = emailText.text ?? ""
        password = passwordText.text ?? ""
        viewModel.login(email: email, password: password)
    }
        
    func navigate(){
//        let registerScreen = storyboard?.instantiateViewController(identifier: "")
        
    }
    
    
    @IBAction func googleLogin(_ sender: Any) {
        
    }
    
    func showAlret(message:String){
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("alert working")
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
