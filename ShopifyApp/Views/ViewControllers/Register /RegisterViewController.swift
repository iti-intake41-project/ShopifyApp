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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        
        if usernameText.text != "" && passwordText.text == confirmPasswordText.text && passwordText.text != "" {
            
            Auth.auth().createUser(withEmail: self.usernameText.text!, password: self.passwordText.text!) { [weak self] (result, error) in
                
                if error != nil {
                    print("error on register \(String(describing: error?.localizedDescription))")
                    //show dialog
                    return
                }
                print("register successfully")
                print("result: \(result!.user.uid)")
                //Navigate
                self?.performSegue(withIdentifier: "navigationToLogin", sender: nil)
            }
        } else{
            //show dialog
        }
    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        
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
