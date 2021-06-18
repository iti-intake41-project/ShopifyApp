//
//  LoginTableViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 04/06/2021.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class LoginTableViewController: UITableViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var emailText: MDCOutlinedTextField!
    @IBOutlet weak var passwordText: MDCOutlinedTextField!
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var viewModel: LoginViewModelTemp!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    var email, password: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel(appDelegate: &delegate)
        bindToViewModel()
        setUI()
    }
    
    func setUI(){
        emailText.label.text = "Email"
        passwordText.label.text = "Password"
        emailText.containerRadius = emailText.layer.frame.height / 2
        passwordText.containerRadius = passwordText.layer.frame.height / 2
        loginBtn.layer.cornerRadius = registerBtn.layer.frame.height / 2
        registerBtn.layer.cornerRadius = registerBtn.layer.frame.height / 2
    }
    
    func bindToViewModel(){
        viewModel.bindNavigate = { [weak self] in
            self?.navigate()
        }
        
        viewModel.bindDontNavigate = { [weak self] in
            let message = self?.viewModel.alertMessage ?? "Can't login, please check your info"
            self?.showAlret(message: message)
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        email = emailText.text ?? ""
        password = passwordText.text ?? ""
        indicator.isHidden = false
        view.isUserInteractionEnabled = false
        viewModel.login(email: email, password: password)
    }
        
    func navigate(){
//        let mainScreen = storyboard?.instantiateViewController(withIdentifier: "main")
//        mainScreen?.modalPresentationStyle = .fullScreen
//        present(mainScreen!, animated: true, completion: nil)
//        performSegue(withIdentifier: "navigateToMain", sender: self)
//        dismiss(animated: true, completion: nil)
        indicator.isHidden = true
        view.isUserInteractionEnabled = true
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func navigateToRegister(_ sender: Any) {
//        let registerScreen = storyboard?.instantiateViewController(withIdentifier: "RegisterTableViewController")
//        registerScreen?.modalPresentationStyle = .fullScreen
//        present(registerScreen!, animated: true, completion: nil)
        performSegue(withIdentifier: "navToReg", sender: self)
        
    }
    
    func showAlret(message:String){
        indicator.isHidden = true
        view.isUserInteractionEnabled = true

        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("alert working")
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
