//
//  LoginViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 22/05/2021.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self 
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: UIButton) {
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: self.emailText.text!, password: self.passwordText.text!) { (result, error) in
                
                if error != nil {
                    print("error on login \(String(describing: error?.localizedDescription))")
                    //show dialog
                    return
                }
                print("login successfully")
                print("resultt: \(result!.user.uid)")
                //Navigate
                
            }
        } else{
            //show dialog
        }

    }
    
    
    @IBAction func googleLogin(_ sender: UIButton) {
        
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        
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
