//
//  LoginTableViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 04/06/2021.
//

import UIKit
//import Firebase
//import GoogleSignIn

class LoginTableViewController: UITableViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var viewModel: LoginViewModelTemp!
    var email, password: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel(appDelegate: &delegate)
        bindToViewModel()
//        GIDSignIn.sharedInstance()?.presentingViewController = self

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
        viewModel.login(email: email, password: password)
    }
        
    func navigate(){
//        let registerScreen = storyboard?.instantiateViewController(withIdentifier: "main")
//        registerScreen?.modalPresentationStyle = .fullScreen
//        present(registerScreen!, animated: true, completion: nil)
        performSegue(withIdentifier: "navigateToMain", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func navigateToRegister(_ sender: Any) {
        let registerScreen = storyboard?.instantiateViewController(withIdentifier: "RegisterTableViewController")
        registerScreen?.modalPresentationStyle = .fullScreen
        present(registerScreen!, animated: true, completion: nil)
        
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
