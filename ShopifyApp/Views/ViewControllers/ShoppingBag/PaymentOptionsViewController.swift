//
//  PaymentOptionsViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 16/06/2021.
//

import UIKit

class PaymentOptionsViewController: UIViewController {
    @IBOutlet weak var paymentOptionsTable: UITableView!
    let payments = ["online", "POD"]
    var currentType = "POD"
    var address: Address!
    var orders: [Product]!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var paymentBtn: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        paymentOptionsTable.delegate = self
        paymentOptionsTable.dataSource = self
        viewBtn.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        paymentBtn.layer.cornerRadius = paymentBtn.layer.frame.height / 2
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toPayment" {
            if let nextViewController = segue.destination as? checkoutViewController {
                nextViewController.orders = orders
                nextViewController.address = address
                nextViewController.paymentType = currentType
            }
        }
    }
    
    @IBAction func navigateToCheckout(_ sender: Any) {
        print("address: \(address) paymentType: \(currentType)")
        print("orders: \(orders)")
        performSegue(withIdentifier: "toPayment", sender: self)
    }
    

}

// MARK: - TableView
extension PaymentOptionsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentOptionsTable.dequeueReusableCell(withIdentifier: "shoppingBagCell", for: indexPath) as! PaymentMethodCell
        cell.payment = payments[indexPath.row]
        switch indexPath.section {
        case 0:
            cell.payment = payments[0]
            cell.paymentText.text = "Paynow and get free delivery"
        case 1:
            cell.payment = payments[1]
            cell.paymentText.text = "Cash On Delivery (COD)"

        default:
            cell.payment = payments[1]
            cell.paymentText.text = "Cash On Delivery (COD)"
        }
        cell.delegate = self
        if currentType == cell.payment {
            cell.mybtton.tintColor = UIColor.blue
        }else{
            cell.mybtton.tintColor = UIColor.white
        }
        print("cell type:\(cell.payment) current type: \(currentType)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch section {
        case 0:
            title = "Online Payment"
        default:
            title = "More payment options"
        }
        return title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }


}


// MARK: - Table Cell

class PaymentMethodCell: UITableViewCell{
    var delegate: PaymentMethodDelegate!
    var payment: String = "POD"
    @IBOutlet weak var mybtton: UIButton!
    @IBOutlet weak var paymentText: UITextField!
    
    @IBAction func changePaymentMethod(_ sender: Any) {
        delegate.chooseAsMain(method: payment)
    }
    
}



// MARK: - Payment Method Delegate
protocol PaymentMethodDelegate {
    func chooseAsMain(method: String)
}


extension PaymentOptionsViewController: PaymentMethodDelegate{
    func chooseAsMain(method: String) {
        currentType = method
        paymentOptionsTable.reloadData()
    }
        
}
