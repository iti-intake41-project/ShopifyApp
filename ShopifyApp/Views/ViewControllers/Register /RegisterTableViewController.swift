//
//  RegisterTableViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 04/06/2021.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class RegisterTableViewController: UITableViewController {
    
    @IBOutlet weak var firstNameText: MDCOutlinedTextField!
    @IBOutlet weak var lastNameText: MDCOutlinedTextField!
    @IBOutlet weak var emailText: MDCOutlinedTextField!
    @IBOutlet weak var passwordText: MDCOutlinedTextField!
    @IBOutlet weak var confirmPasswordText: MDCOutlinedTextField!
    var firstName, lastName, email, password, confirmPassword: String!
    @IBOutlet weak var registerBtn: UIButton!
    var viewModel: RegisterViewModelTemp = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        
        
        let estimatedFrame = CGRect(x: 25, y: 10, width: self.view.frame.width - 50, height: 30)
        let textField = MDCOutlinedTextField(frame: estimatedFrame)
        textField.sizeToFit()
        
        setUI()
    }
    func setUI(){
        let fields = [firstNameText, lastNameText, emailText, passwordText, confirmPasswordText]
        firstNameText.label.text = "First Name"
        lastNameText.label.text = "Last Name"
        emailText.label.text = "Email"
        passwordText.label.text = "Password"
        confirmPasswordText.label.text = "Confirm Password"
        registerBtn.layer.cornerRadius = registerBtn.layer.frame.height / 2
        for field in fields{
            field?.containerRadius = field!.layer.frame.height / 2
            field?.layer.frame = CGRect(x: 25, y: 10, width: self.view.frame.width - 50, height: 20)
            field?.sizeToFit()
            field?.textColor = UIColor.red
        }
    }
    
    func bindToViewModel(){

        let _ = viewModel.alertMsgDriver.drive(onNext: {
            [weak self] (message) in
            (self?.showAlret(message: message))
        }, onCompleted: nil, onDisposed:nil )
        
        viewModel.navigateToMain = { [weak self] in
            print("navigate to main from controller")
            self?.performSegue(withIdentifier: "navigateToMainFromRegister", sender: self)
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
