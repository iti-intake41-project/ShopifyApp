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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    var viewModel: AddressViewModelTemp!
    var delegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressViewModel(appDelegate: &delegate)
        bindToViewModel()
        self.view.isUserInteractionEnabled = true
        //        indicator.isHidden = true
       
    }
    
    func bindToViewModel(){
        viewModel.viewShowAlret = { [weak self] in
            print("viewShowAlret")
            if let message = self?.viewModel.message{
                DispatchQueue.main.async {
                    self?.view.isUserInteractionEnabled = true
                    self?.indicator.isHidden = true
                    self?.showAlret(message: message)
                }
            }
        }
        viewModel.navigateToCheckOut = { [weak self] in
            // navigate to checkOut screen
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = true
                self?.indicator.isHidden = true
                print("navigate to checkOut screen")
                
            }
        }
    }
    
    @IBAction func addAddress(_ sender: Any) {
        indicator.isHidden = false
        view.isUserInteractionEnabled = false
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
