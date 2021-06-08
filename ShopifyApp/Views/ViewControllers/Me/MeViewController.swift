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
    @IBOutlet weak var imgFav1: UIImageView!
    @IBOutlet weak var imgFav3: UIImageView!
    @IBOutlet weak var lblFav1: UILabel!
    @IBOutlet weak var lblFav2: UILabel!
    @IBOutlet weak var lblFav3: UILabel!
    @IBOutlet weak var imgFav2: UIImageView!
    
    @IBOutlet weak var order3StackView: UIStackView!
    
    @IBOutlet weak var order1StackVIew: UIStackView!
    
    @IBOutlet weak var fav1StackView: UIStackView!
    @IBOutlet weak var order2StackView: UIStackView!
    @IBOutlet weak var fav2StackView: UIStackView!
    @IBOutlet weak var fav3StackView: UIStackView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setOrderesUI(products: getOrders())
        
    }
    @IBAction func gotTOOrders(_ sender: UIButton) {
    }
    
    @IBAction func goToShoppingBag(_ sender: UIButton) {
        
//        let ShopViewController = storyboard?.instantiateViewController(withIdentifier: "ShopViewController") as! ShoppingBagViewController
//        ShopViewController.modalPresentationStyle = .fullScreen
//
//        present(ShopViewController, animated: true, completion: nil)
//         performSegue(withIdentifier: "ShoppingBag", sender: self)
    }
    
    @IBAction func goTOWishList(_ sender: UIButton) {
    }
    @IBAction func gotoSetting(_ sender: Any) {
    }
    func getOrders() ->[Product]{
        let shoppingBagViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        return shoppingBagViewModel.getShoppingCartProductList()
       
    }
    func setOrderesUI(products:[Product]) {
        if products.count == 1 {
               imgOrder1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
                   lblOrder1.text = products[0].title
            order2StackView.isHidden = true
            order3StackView.isHidden = true

               }
               
               else if products.count >= 3 {
                 imgOrder1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
                 imgOrder2.sd_setImage(with:URL(string:products[1].images[0].src), placeholderImage: UIImage(named: "noImage"))
               imgOrder3.sd_setImage(with:URL(string:products[2].images[0].src), placeholderImage: UIImage(named: "noImage"))
            lblOrder1.text = products[0].varients?[0].price
            lblOrder2.text = products[1].varients?[0].price
            lblOrder3.text = products[2].varients?[0].price
           
            print(products[2].title)
            

                   }
               else if products.count == 2 {
                 imgOrder1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
                   imgOrder2.sd_setImage(with:URL(string:products[1].images[0].src), placeholderImage: UIImage(named: "noImage"))
               
                lblOrder1.text = products[0].title
                lblOrder2.text = products[1].title
                order3StackView.isHidden = true

                   
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