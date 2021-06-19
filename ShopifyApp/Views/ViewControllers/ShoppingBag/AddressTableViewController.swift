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
    @IBOutlet weak var phoneText: MDCOutlinedTextField!
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var addressDelegate: UpdateAddressList!
    var isEdit: Bool = false
    var editAddress: Address!
    
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
        phoneText.label.text = "Phone"
        addAddressBtn.layer.cornerRadius = addAddressBtn.layer.frame.height / 2
        if isEdit {
            addAddressBtn.setTitle("EDIT ADDRESS", for: .normal)
            countryText.text = editAddress.country
            cityText.text = editAddress.city
            addressText.text = editAddress.address1
            phoneText.text = editAddress.phone
        }
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
                if self?.addressDelegate != nil {
                    self?.addressDelegate.updateAddressList()
                }
                self?.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    
    @IBAction func addAddress(_ sender: Any) {
        indicator.isHidden = false
        view.isUserInteractionEnabled = false
        if isEdit{
            editAddress.country = countryText.text ?? ""
            editAddress.city = cityText.text ?? ""
            editAddress.address1 = addressText.text ?? ""
            editAddress.phone = phoneText.text ?? ""
            viewModel.editAddress(address: editAddress)
        }else{
            viewModel.addAddress(country: countryText.text ?? "", city: cityText.text ?? "", address: addressText.text ?? "", phone: phoneText.text ?? "")
        }
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
