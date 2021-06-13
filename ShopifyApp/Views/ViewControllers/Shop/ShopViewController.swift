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
    @IBOutlet weak var collectionImg1: UIImageView!
    @IBOutlet weak var collectionImg2: UIImageView!
    
    @IBOutlet weak var collectionImg4: UIImageView!
    @IBOutlet weak var collectionImg3: UIImageView!
    var products: [Product] = [Product]()
    var collections = [CustomCollections]()
    let shopViewModel: ShopViewModel = ShopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        productSearchBar.delegate = self
        shopViewModel.fetchCustomCollection()
        shopViewModel.bindShopViewModelToView = onSuccessUpdateView
    }
    
    
    
    func onSuccessUpdateView() {
        guard let collections = shopViewModel.customCollections else {
            print("no collections")
            return
        }
        self.collections = collections
        for i in collections {
            print(i.title)
        }
        collectionLbl1.text = collections[4].title
        collectionLbl2.text = collections[1].title
        collectionLbl3.text = collections[3].title
        collectionLbl4.text = collections[2].title
        collectionImg1.sd_setImage(with: URL(string: collections[4].image?.src ?? ""), placeholderImage: UIImage(named: "noImage"))
        collectionImg2.sd_setImage(with: URL(string: collections[1].image?.src ?? ""), placeholderImage: UIImage(named: "noImage"))
        collectionImg3.sd_setImage(with: URL(string: collections[2].image?.src ?? ""), placeholderImage: UIImage(named: "noImage"))
        collectionImg4.sd_setImage(with: URL(string: collections[3].image?.src ?? ""), placeholderImage: UIImage(named: "noImage"))
        
    }
    func onFailUpdateView() {
        let alert = UIAlertController(title: "Error", message: shopViewModel.showError, preferredStyle: .alert)
        
        let okAction  = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            
        }
        
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shoppingBagAction(_ sender: Any) {
        if shopViewModel.isLoggedIn() {
            performSegue(withIdentifier: "card", sender: self)
            
        }else{
            performSegue(withIdentifier: "login", sender: self)
        }
        
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        if shopViewModel.isLoggedIn() {
            performSegue(withIdentifier: "fav", sender: self)
            
        }else{
            performSegue(withIdentifier: "login", sender: self)
        }
    }
    
    @IBAction func adsAction(_ sender: Any) {
    }
    
    @IBAction func homeAction(_ sender: Any) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        print(collections.count)
        if collections.count != 0{
            if segue.identifier == "col1" {
                let vc = segue.destination as! ProductListViewController
                vc.collectionID = collections[4]
            }
            else if segue.identifier == "col2"{
                let vc = segue.destination as! ProductListViewController
                vc.collectionID = collections[1]
                print("kids")
            }else if segue.identifier == "col3" {
                let vc = segue.destination as! ProductListViewController
                vc.collectionID = collections[2]
            }else if segue.identifier == "col4"{
                let vc = segue.destination as! ProductListViewController
                vc.collectionID = collections[3]
            }
        }
    }
    
    
    @IBAction func menAction(_ sender: Any) {
    }
    
    @IBAction func womenAction(_ sender: Any) {
        
    }
    
    @IBAction func kidsAction(_ sender: Any) {
        
    }
}
extension ShopViewController:UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        collections = shopViewModel.searchProduct(sProducts: collections, searchTxt: searchText)
        
        //    collectionLbl1.text = collections[0].title
        
        
    }
    
    
    
    
    
}
