//
//  ShopViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 5/22/21.
//

import UIKit

class ShopViewController: UIViewController{
    
    @IBOutlet weak var productSearchBar: UISearchBar!
    @IBOutlet weak var adsImage: UIImageView!
    @IBOutlet weak var collectionLbl1: UILabel!
    @IBOutlet weak var collectionLbl2: UILabel!
    @IBOutlet weak var collectionLbl3: UILabel!
    @IBOutlet weak var collectionLbl4: UILabel!
    
    var products: [Product] = [Product]()
    var collections = [CustomCollections]()
    let shopViewModel: ShopViewModel = ShopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // Do any additional setup after loading the view.
        productSearchBar.delegate = self
        //        shopViewModel.bindShopViewModelToView  = onSuccessUpdateView
        //        shopViewModel.bindViewModelErrorToView = onFailUpdateView
        //call  products from viewController based on collectionID
        shopViewModel.fetchCustomCollection()
        shopViewModel.bindShopViewModelToView = onSuccessUpdateView
        //shopViewModel.fetchAllProductsFromAPI()
        ////
        //        performSegue(withIdentifier: "productlist", sender: self)
    }
    
    
    
    func onSuccessUpdateView() {
        //      guard let products = shopViewModel.allProducts
        //       else {
        //        print("no products")
        //        return }
        //        self.products = products
        //
        //        print(products.count)
        //        print(products[0].title)
        //        print(products[0].productType!)
        //        print("-------------------------")
        guard let collections = shopViewModel.customCollections else {
            print("no collections")
            return
        }
        self.collections = collections
        for i in collections {
            print(i.title)
        }
        collectionLbl1.text = collections[0].title
        collectionLbl2.text = collections[1].title
        collectionLbl3.text = collections[3].title
        collectionLbl4.text = collections[2].title
        
        
    }
    func onFailUpdateView() {
        let alert = UIAlertController(title: "Error", message: shopViewModel.showError, preferredStyle: .alert)
        
        let okAction  = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            
        }
        
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shoppingBagAction(_ sender: Any) {
        
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
    }
    
    @IBAction func adsAction(_ sender: Any) {
    }
    
    @IBAction func homeAction(_ sender: Any) {
        print("home action")
        let productList = ProductListViewController()
        if collections.count != 0 {
            productList.collectionID = "\(collections[0].id)"
            prepare(for: UIStoryboardSegue(identifier: "productList", source: self, destination: productList), sender: self)
            performSegue(withIdentifier: "productList", sender: self)
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        
        if segue.identifier == "productList" {
            let vc = segue.destination as! ProductListViewController
            vc.collectionID = "\(collections[0].id)"
        }
        else if segue.identifier == "kids"{
            let vc = segue.destination as! ProductListViewController
            vc.collectionID = "\(collections[1].id)"
            print("kids")
        }else if segue.identifier == "colection3" {
            let vc = segue.destination as! ProductListViewController
            vc.collectionID = "\(collections[2].id)"
        }else if segue.identifier == "colection4"{
            let vc = segue.destination as! ProductListViewController
            vc.collectionID = "\(collections[3].id)"
        }
        
    }
    
    
    @IBAction func menAction(_ sender: Any) {
        //collectionLbl2
        let productList = ProductListViewController()
        if collections.count != 0 {
        productList.collectionID = "\(collections[0].id)"
        prepare(for: UIStoryboardSegue(identifier: "kids", source: self, destination: productList), sender: self)
        performSegue(withIdentifier: "kids", sender: self)
        }
    }
    
    @IBAction func womenAction(_ sender: Any) {
        //collectionLbl3
        
        let productList = ProductListViewController()
        if collections.count != 0 {
        productList.collectionID = "\(collections[3].id)"
        prepare(for: UIStoryboardSegue(identifier: "colection3", source: self, destination: productList), sender: self)
        performSegue(withIdentifier: "colection3", sender: self)
        }
    }
    
    @IBAction func kidsAction(_ sender: Any) {
        //collectionLbl4
        
        let productList = ProductListViewController()
        if collections.count != 0 {
        productList.collectionID = "\(collections[4].id)"
        prepare(for: UIStoryboardSegue(identifier: "colection4", source: self, destination: productList), sender: self)
        performSegue(withIdentifier:"colection4",sender: self)
        }
        
    }
}
extension ShopViewController:UISearchBarDelegate{

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText)
        collections = shopViewModel.searchProduct(sProducts: collections, searchTxt: searchText)
        
    //    collectionLbl1.text = collections[0].title
        
        
    }
    
    
    
                 
     
}
