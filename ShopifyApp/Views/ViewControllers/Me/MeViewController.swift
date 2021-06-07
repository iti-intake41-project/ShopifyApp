//
//  MeViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/7/21.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet weak var imgOrder1: UIImageView!
    @IBOutlet weak var lblOrder1: UILabel!
    
    @IBOutlet weak var imgOrder2: UIImageView!
    
    @IBOutlet weak var imgOrder3: UIImageView!
    @IBOutlet weak var lblOrder2: UILabel!
    @IBOutlet weak var lblOrder3: UILabel!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var products = [Product]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       products = getOrders()
        if products.count == 1 {
        imgOrder1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
            lblOrder1.text = products[0].title
        }
        
        else if products.count >= 3 {
          imgOrder1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
          imgOrder2.sd_setImage(with:URL(string:products[1].images[0].src), placeholderImage: UIImage(named: "noImage"))
        imgOrder3.sd_setImage(with:URL(string:products[2].images[0].src), placeholderImage: UIImage(named: "noImage"))
            lblOrder1.text = products[0].title
            lblOrder2.text = products[1].title
            lblOrder3.text = products[2].title
       
            print(products[2].title)

            }
        else if products.count == 2 {
          imgOrder1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
            imgOrder2.sd_setImage(with:URL(string:products[1].images[0].src), placeholderImage: UIImage(named: "noImage"))
        
         lblOrder1.text = products[0].title
         lblOrder2.text = products[1].title

            
        }
    }
    
    func getOrders() ->[Product]{
        let shoppingBagViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        return shoppingBagViewModel.getProductList()
       
        
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
