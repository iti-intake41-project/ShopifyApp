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
    //var order:Order?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  

}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderDetailsTableViewCell
        
        cell.name.text = "test"
        cell.orderImage.image = UIImage(named: "pic")
        cell.price.text = "Price: 52 Usd"
        cell.quantity.text = "Quantity: 5"
        return cell
    }
    
    
}
