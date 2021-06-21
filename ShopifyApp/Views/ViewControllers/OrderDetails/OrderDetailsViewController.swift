//
//  OrderDetailsViewController.swift
//  ShopifyApp
//
//  Created by Abanob Wadie on 19/06/2021.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var oderIdLabel: UILabel!
    @IBOutlet weak var shippingToLabel: UILabel!
    @IBOutlet weak var orderDetailsTableView: UITableView!
    var order:Order?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        oderIdLabel.text = "\(order?.created_at ?? "")"
        shippingToLabel.text = order?.customer.first_name
    }
    

  

}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.line_items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderDetailsTableViewCell
        
        cell.name.text = order?.line_items[indexPath.row].name
      //  cell.orderImage.image = UIImage(named: "pic")
        cell.price.text = order?.line_items[indexPath.row].price
        cell.quantity.text = "\(order?.line_items[indexPath.row].quantity ?? 0)"
        return cell
    }
    
    
}
