//
//  ShowAdressViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 17/06/2021.
//

import UIKit

class ShowAdressViewController: UIViewController {
    @IBOutlet weak var addressTable: UITableView!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var addresses: [Address] = []
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var viewModel: ShowAddressViewModel!
    var editAddress: Address!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ShowAddressViewModel(delegate: &delegate)
        addressTable.delegate = self
        addressTable.dataSource = self
        bindViewModel()
        //        getAddresses()
        setUI()
        
    }
    
    func bindViewModel(){
        viewModel.showAddresses = {
            DispatchQueue.main.async {
                self.indicator.isHidden = true
                self.view.isUserInteractionEnabled = true
                self.addresses = self.viewModel.addresses!
                self.addressTable.reloadData()
                
                if self.addresses.count == 0 {
                    let imageView = UIImageView(image: UIImage(named: "noSearch"))
                    imageView.contentMode = .scaleAspectFill
                    self.addressTable.backgroundView = imageView
                }else{
                    self.addressTable.backgroundView = nil
                }
            }
        }
        viewModel.cantDeleteAddress = {
            DispatchQueue.main.async {
                self.indicator.isHidden = true
                self.view.isUserInteractionEnabled = true
                self.showErrorAlret()
            }
        }
        viewModel.getAddresses()
    }
    
    //    func getAddresses(){
    //        //addresses =
    //        print("addresses: \(addresses)")
    //        addressTable.reloadData()
    //    }
    
    func setUI(){
        indicator.isHidden = true
        viewBtn.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        addBtn.layer.cornerRadius = addBtn.layer.frame.height / 2
    }
    
    @IBAction func navigateToAddAddress(_ sender: Any) {
        performSegue(withIdentifier: "navToAddAddress", sender: self)
    }
    
    func navigateToEditAddress(){
        performSegue(withIdentifier: "NavToEditAddress", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextViewController = segue.destination as? AddressTableViewController {
                nextViewController.addressDelegate = self
            if segue.identifier == "NavToEditAddress" {
                nextViewController.editAddress = editAddress
                nextViewController.isEdit = true
            }
        }
        
    }
    
    func showAlret(){
        let alert = UIAlertController(title: "Default Address", message: "Default address can't be deleted", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlret(){
        let alert = UIAlertController(title: "Error", message: "Can't Delete the address please check your internet connection", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Table View

extension ShowAdressViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTable.dequeueReusableCell(withIdentifier: "AddressesDetailCell", for: indexPath) as! AddressesDetailCell
        cell.countryText.text = addresses[indexPath.section].country
        cell.addressText.text = "\(addresses[indexPath.section].city ?? ""), \(addresses[indexPath.section].address1 ?? "")"
        cell.phoneText.text = addresses[indexPath.section].phone

        return cell
    }
    
    
    //Delete Address
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("indexPath.section: \(indexPath.section)")
            if indexPath.section == 0 {
                showAlret()
            }else{
                viewModel.deleteAddress(addressId: addresses[indexPath.section].id)
                indicator.isHidden = false
                view.isUserInteractionEnabled = false

            }
            
        } else if editingStyle == .insert {
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editAddress = addresses[indexPath.section]
        navigateToEditAddress()
    }
    
    
}

// MARK: - table Cell

class AddressesDetailCell: UITableViewCell {
//    @IBOutlet weak var countryText: UITextField!
//    @IBOutlet weak var addressText: UITextField!
//    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var countryText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var phoneText: UILabel!
    
    
}

// MARK: - Add address delegate
protocol UpdateAddressList {
    func updateAddressList()
}

extension ShowAdressViewController: UpdateAddressList{
    func updateAddressList() {
        viewModel.getAddresses()
    }
}
