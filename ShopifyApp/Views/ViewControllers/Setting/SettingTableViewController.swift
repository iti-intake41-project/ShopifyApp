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
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var logoutStack: UIStackView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var settingViewModel = SettingViewModel()
    var isLoggedIn = false
    var logout = false
    var address:Address?
  //  var delegate:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutBtn.layer.cornerRadius = logoutBtn.layer.frame.height  / 2
        settingViewModel.bindSettingViewModel = onSuccess
       
    }
    override func viewWillAppear(_ animated: Bool) {
        settingViewModel.bindSettingViewModel = onSuccess
               currencytBtn.setTitle(settingViewModel.currency, for: .normal)
               
              address = settingViewModel.getAddress(appDelegate: &appDelegate)
               
        addrbtn.setTitle(settingViewModel.address?.address1, for: .normal)
//               countrybtn.setTitle(settingViewModel.address?.country, for: .normal)
           
        isLoggedIn = settingViewModel.isLoggedIn()
        if !isLoggedIn {
            logoutBtn.isHidden = true
      ///     self.currencytBtn.setTitle("EGP", for: .normal)

        }else{
            logoutBtn.isHidden = false
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
        guard let isLoggedIn = settingViewModel.logout else {
                  print("no logout")
                  return  }
              print(logout)
              
        self.isLoggedIn = isLoggedIn
        guard let address = settingViewModel.address else {
                         print("no currency")
                         return  }
                     print("currency = ")
        self.address = address
        addrbtn.setTitle(address.address1
            , for: .normal)
//        countrybtn.setTitle(address.country, for: .normal)
        
        
        
    }
    
    @IBAction func address(_ sender: UIButton) {
        if settingViewModel.isLoggedIn() {
        if  settingViewModel.hasAddress(appDelegate: &appDelegate){
            //navigate to address
            performSegue(withIdentifier: "showAddress", sender: self)
            }
      
        else{
            performSegue(withIdentifier: "addAddress", sender: self)
            }
            
        }
        else {
            
            performSegue(withIdentifier: "login", sender: self)
            
        }
    }
    
    @IBAction func currency(_ sender: Any) {
        print("currency")
        //if isLoggedIn {
            
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
       // }else{
        //}
        
    }
    
//    @IBAction func country(_ sender: Any) {
//    }
    
    @IBAction func contactus(_ sender: UIButton) {
        let message = """
         email : shopify@gmail.com
         phone : 0100101055
        """
//        getAlert(message: message)
        
        let infoViewController = storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        infoViewController.info = message
        infoViewController.titleText = "Contact us"
        present(infoViewController, animated: true, completion: nil)
    }
    
    @IBAction func aboutUs(_ sender: UIButton) {
        let message = """
        This application is  our graduation project, try use this application and if you found any problem, please contact us to solve it and improve our application.

        Our Team :
            Abanoub Wadie
            Moatez Akram
            Donia Ashraf
            Asmaa Mohamed
        """
//        getAlert(message: message)
        
        let infoViewController = storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        infoViewController.info = message
        infoViewController.titleText = "About us"
        present(infoViewController, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Do You  want Logout from application ?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) {[weak self] (UIAlertAction) in
            self?.addrbtn.setTitle("", for: .normal)
//            self?.countrybtn.setTitle("", for: .normal)
            self?.settingViewModel.logout(appDelegate: &self!.appDelegate)
            self?.logoutBtn.isHidden = true
            self?.viewWillAppear(true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(cancel)
        self.present(alert ,animated: true , completion: nil)
        
    }
    
    func getAlert (message:String){
        
        let alert = UIAlertController(title: "Contact Us", message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction (title: "OK", style: .default ) {(UIAlertAction) in }
        alert.addAction(okAction)
        self.present(alert,animated: true , completion: nil)
    }
}
