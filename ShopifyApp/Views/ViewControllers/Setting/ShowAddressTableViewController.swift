//
//  ShowAddressTableViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/12/21.
//

import UIKit

class ShowAddressTableViewController: UITableViewController {
    
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var addAddressBtn: UIButton!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        addAddressBtn.layer.cornerRadius = addAddressBtn.layer.frame.height / 2
        let settingViewModel = SettingViewModel()
        let address =  settingViewModel.getAddress(appDelegate: &appDelegate)
        country.text = address.country
        city.text = address.city
        self.address.text = address.address1
        if address.zip != "" {
        zipCode.text = address.zip
        }
        else {
//            zipCode.frame =  CGRect(x: 0 , y: 0, width: 0, height: 0)
//
            zipCode.isHidden = true

        }
    
    }
    
    @IBAction func addAddress(_ sender: Any) {
        performSegue(withIdentifier: "addAddr", sender: self)
    }
    
    
}
