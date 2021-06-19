//
//  OrdersTableViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/12/21.
//

import UIKit

class OrdersTableViewController: UITableViewController {

    @IBOutlet var ordersTabelView: UITableView!
    var meViewModel = MeViewModel()
    var orders = [Order]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meViewModel.bindOrders = {
            self.orders = self.meViewModel.orders
                  self.ordersTabelView.reloadData()
            print("orders count \(self.orders.count)")
              }
        orders = meViewModel.getOrders()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell

        // Configure the cell...
        cell.priceLbl.text = orders[indexPath.row].current_total_price
        cell.creationDatelbl.text = orders[indexPath.row].created_at
        
        

        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Orders"
    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
//
//        headerView.backgroundColor = UIColor.white
//        return headerView
//    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.systemPink
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               let alert = UIAlertController(title: "Do you Want to Delete Order", message: nil, preferredStyle: .alert)
               let yes = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            //       self.meViewModel.deleteOrder(orderId: self.orders[indexPath.row].id!)
                   self.orders.remove(at: indexPath.row)
                   tableView.deleteRows(at: [indexPath], with: .none)
           
                   self.ordersTabelView.reloadData()
                   print("editing delete")
               }
               let no = UIAlertAction(title: "No", style: .default , handler: nil)
               alert.addAction(yes)
               alert.addAction(no)
               self.present(alert, animated: true, completion: nil)
           }
       }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
