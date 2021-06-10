//
//  AddressTableViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 10/06/2021.
//

import UIKit

class AddressTableViewController: UITableViewController {
    
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var zipcodeText: UITextField!
    
    var viewModel: AddressViewModel!
    var delegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressViewModel(appDelegate: &delegate)
        
    }
    
    func bindToViewModel(){
        viewModel.alretDidAppear = { [weak self] in
//            self?.addAddress(self?.viewModel.message)
        }
    }

    @IBAction func addAddress(_ sender: Any) {
        viewModel.addAddress(country: countryText.text ?? "", city: cityText.text ?? "", address: addressText.text ?? "", zipcode: zipcodeText.text ?? "")
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
