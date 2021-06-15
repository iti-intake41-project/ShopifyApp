//
//  ChooseAddressViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 15/06/2021.
//

import UIKit

class ChooseAddressViewController: UIViewController {
    
    @IBOutlet weak var addressTable: UITableView!
    var addresses: [Address] = []
    var viewModel: ChooseAddressViewModel!
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var shippingAddressId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startView()
    }
    
    func startView(){
        addressTable.delegate = self
        addressTable.dataSource = self
        viewModel = ChooseAddressViewModel(appDelegate: &delegate)
        addresses = viewModel.getAddresses()
        shippingAddressId = addresses[0].id
        print("default id: \(shippingAddressId)")
        print("count: \(addresses.count)")
//        addresses[0].isMainAddress = true
        addressTable.reloadData()
        viewModel.reloadTable = { [weak self] in
            self?.addressTable.reloadData()
        }
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

// MARK: - Table View
extension ChooseAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTable.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressDetailCell
        cell.address = addresses[indexPath.row]
        cell.delegate = self
        if shippingAddressId != addresses[indexPath.row].id {
            cell.mybutton.tintColor = UIColor.white
        }else{
            cell.mybutton.tintColor = UIColor.blue
        }
        return cell
    }
    
    
}

// MARK: - Table Cell

class AddressDetailCell: UITableViewCell{
    
    @IBOutlet private weak var countryText: UITextField!
    @IBOutlet private weak var addressText: UITextField!
    
    var delegate: MainAddressDelegate!
    
    @IBOutlet weak var mybutton: UIButton!
    var address: Address! {
        didSet{
            countryText.text = address.country
            addressText.text = "\(address.country ?? ""), \(address.address1 ?? "")"
        }
    }
    
    
    @IBAction func changeAddress(_ sender: Any) {
        delegate.chooseAsMain(addressId: address.id!)
    }
    
    
}

// MARK: - Main Address Delegate
protocol MainAddressDelegate {
    func chooseAsMain(addressId: Int)
}


extension ChooseAddressViewController: MainAddressDelegate{
    
    func chooseAsMain(addressId: Int) {
        shippingAddressId = addressId
        print("pressed id \(addressId)")
        addressTable.reloadData()
    }
    
}
