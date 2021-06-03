//
//  ShopViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 5/22/21.
//

import UIKit

class ShopViewController: UIViewController {

    var products: [Product] = [Product]()
    let shopViewModel: ShopViewModel = ShopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        shopViewModel.bindShopViewModelToView  = onSuccessUpdateView
//        shopViewModel.bindViewModelErrorToView = onFailUpdateView
        //call  products from viewController based on collectionID
        shopViewModel.fetchCustomCollection()
        //shopViewModel.fetchAllProductsFromAPI()
        
        performSegue(withIdentifier: "productlist", sender: self)
    }
    func onSuccessUpdateView() {
      guard let products = shopViewModel.allProducts
       else {
        print("no products")
        return }
        self.products = products

        print(products.count)
        print(products[0].title)
        print(products[0].productType!)
        print("-------------------------")
    }
    func onFailUpdateView() {
        let alert = UIAlertController(title: "Error", message: shopViewModel.showError, preferredStyle: .alert)
             
             let okAction  = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                 
                 
             }
             
             
             alert.addAction(okAction)
             self.present(alert, animated: true, completion: nil)
    }

}
