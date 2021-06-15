//
//  AddressTableViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 10/06/2021.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class AddressTableViewController: UITableViewController {
    
    @IBOutlet weak var countryText: MDCOutlinedTextField!
    @IBOutlet weak var cityText: MDCOutlinedTextField!
    @IBOutlet weak var addressText: MDCOutlinedTextField!
    @IBOutlet weak var zipcodeText: MDCOutlinedTextField!
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    var viewModel: AddressViewModelTemp!
    var delegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressViewModel(appDelegate: delegate)
        bindToViewModel()
        self.view.isUserInteractionEnabled = true
        setUI()
    }
    
    func setUI(){
        countryText.label.text = "Coutry"
        cityText.label.text = "City"
        addressText.label.text = "Address"
        zipcodeText.label.text = "Zipcode"
        addAddressBtn.layer.cornerRadius = addAddressBtn.layer.frame.height / 2
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
                self?.navigationController?.popViewController(animated: true)
                
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
