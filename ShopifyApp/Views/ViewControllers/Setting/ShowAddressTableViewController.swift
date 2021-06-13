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
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        let settingViewModel = SettingViewModel()
        let address =  settingViewModel.getAddress(appDelegate: &appDelegate)
        country.text = address.country
        city.text = address.city
        self.address.text = address.address1
        if address.zip != "" {
        zipCode.text = address.zip
        }
        else {
            zipCode.isHidden = true

        }
    
    }
    
    
}
