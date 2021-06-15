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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startView()
    }
    
    func startView(){
        addressTable.delegate = self
        addressTable.dataSource = self
        viewModel = ChooseAddressViewModel(appDelegate: &delegate)
        addresses = viewModel.getAddresses()
//        addresses[0].isMainAddress = true
        addressTable.reloadData()
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
        return cell
    }
    
    
}

// MARK: - Table Cell

class AddressDetailCell: UITableViewCell{
    
    @IBOutlet private weak var countryText: UITextField!
    @IBOutlet private weak var addressText: UITextField!
    
    var address: Address! {
        didSet{
            countryText.text = address.country
            addressText.text = "\(address.country ?? ""), \(address.address1 ?? "")"
        }
    }
    
    override class func awakeFromNib() {
        
    }
    
}

// MARK: - Main Address Delegate
protocol MainAddressDelegate {
    func chooseAsMain()
}
