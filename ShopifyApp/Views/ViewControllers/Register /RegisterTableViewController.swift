//
//  RegisterTableViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 04/06/2021.
//

import UIKit

class RegisterTableViewController: UITableViewController {
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    var firstName, lastName, email, password, confirmPassword: String!
    let viewModel: RegisterViewModelTemp = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
    }
    
    func bindToViewModel(){
        let _ = viewModel.alertMsgDriver.drive {[weak self] (message) in
            self?.showAlret(message: message)
        } onCompleted: {
            
        } onDisposed: {
            
        }
    }

    
    @IBAction func register(_ sender: UIButton) {
        firstName = firstNameText.text ?? ""
        lastName = lastNameText.text ?? ""
        email = emailText.text ?? ""
        password = passwordText.text ?? ""
        confirmPassword = confirmPasswordText.text ?? ""
        
        viewModel.registerCustomer(firstName: firstName, lastName: lastName, email: email, password: password, confirmPassword: confirmPassword)
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
