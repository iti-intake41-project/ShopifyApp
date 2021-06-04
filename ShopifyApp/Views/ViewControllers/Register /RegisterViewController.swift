//
//  RegisterViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 22/05/2021.
//

import UIKit
import Firebase
import GoogleSignIn


class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    let viewModel:RegisterViewModelTemp = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
    }
    
    func bindToViewModel(){
        viewModel.alertMsgDriver.drive {[weak self] (message) in
            self?.showAlret(message: message)
        } onCompleted: {
            
        } onDisposed: {
            
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        let pass = passwordText.text ?? ""
        let confirmPass = confirmPasswordText.text ?? ""
        viewModel.registerCustomer(firstName: "123", lastName: "", email: "", password: pass, confirmPassword: confirmPass)
        
//        if usernameText.text != "" && passwordText.text == confirmPasswordText.text && passwordText.text != "" {
//
//            Auth.auth().createUser(withEmail: self.usernameText.text!, password: self.passwordText.text!) { [weak self] (result, error) in
//
//                if error != nil {
//                    print("error on register \(String(describing: error?.localizedDescription))")
//                    //show dialog
//                    return
//                }
//                print("register successfully")
//                print("result: \(result!.user.uid)")
//                //Navigate
//                self?.performSegue(withIdentifier: "navigationToLogin", sender: nil)
//            }
//        } else{
//            //show dialog
//        }
    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        
    }
    
    func showAlret(message:String){
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("alert working")
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
