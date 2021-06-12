//
//  SettingTableViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/8/21.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    @IBOutlet weak var addrbtn: UIButton!
    @IBOutlet weak var currencytBtn: UIButton!
    
    @IBOutlet weak var countrybtn: UIButton!
    
    @IBOutlet weak var logoutStack: UIStackView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var settingViewModel = SettingViewModel()
    var isLoggedIn = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingViewModel.bindSettingViewModel = onSuccess
        currencytBtn.setTitle(settingViewModel.currency, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
         isLoggedIn = settingViewModel.isLoggedIn()
        if !isLoggedIn {
            logoutStack.isHidden = true
        }
    }
    
    func onSuccess() {
        //        print("before ")
        
        guard let currency = settingViewModel.currency else {
            print("no currency")
            return  }
        print("currency = ")
        
        self.currencytBtn.setTitle(currency, for: .normal)
        
        print("after ")
        
    }
    
    @IBAction func address(_ sender: UIButton) {
        addrbtn.setTitle("rjrge;r", for: .normal)
        
    }
    
    @IBAction func currency(_ sender: Any) {
        print("currency")
        if isLoggedIn {
        
        let alert = UIAlertController(title: "Choose Currency", message: nil, preferredStyle: .alert)
        
        let usd  = UIAlertAction(title: "USD", style: .default) { (UIAlertAction) in
            self.settingViewModel.setCurrency(key: "currency", value: "USD")
            self.currencytBtn.setTitle(self.settingViewModel.currency, for: .normal)
            
        }
        let egp  = UIAlertAction(title: "EGP", style: .default) { (UIAlertAction) in
           
            self.settingViewModel.setCurrency(key: "currency", value: "EGP")
          
            
        }
        
        alert.addAction(usd)
        alert.addAction(egp)
        self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func country(_ sender: Any) {
    }
    
    @IBAction func contactus(_ sender: UIButton) {
        let message = """
         email : shopify@gmail.com
         phone : 0100101055
"""
        getAlert(message: message)
        
    }
    
    @IBAction func aboutUs(_ sender: UIButton) {
        let message = """
        this application is  our graduation project, try use this application and if you found any problem, please contact us to solve it and improve our application.

                Our team :
                    Moatez Akram
                    Donia Ashraf
                    Asmaa Mohamed
                    Abanob Wadie
        """
        getAlert(message: message)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        
        settingViewModel.logout(appDelegate: &appDelegate)
        logoutStack.isHidden = true
    
    }
    
    func getAlert (message:String){
        
        let alert = UIAlertController(title: "Contact Us", message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction (title: "OK", style: .default ) {(UIAlertAction) in }
        alert.addAction(okAction)
        self.present(alert,animated: true , completion: nil)
    }
}
