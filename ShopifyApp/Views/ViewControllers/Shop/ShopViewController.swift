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
    @IBOutlet weak var imgCollection1: UIImageView!
    @IBOutlet weak var imgCollection2: UIImageView!
    @IBOutlet weak var imgCollection3: UIImageView!
    @IBOutlet weak var imgCollection4: UIImageView!
    
    var products: [Product] = [Product]()
    var collections = [CustomCollections]()
    var adds: [DiscountCode] = [DiscountCode]()
    let shopViewModel: ShopViewModel = ShopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // Do any additional setup after loading the view.
        productSearchBar.delegate = self
        shopViewModel.fetchCustomCollection()
        shopViewModel.bindCategoryViewModelToView = onSuccessUpdateView
        shopViewModel.bindViewModelErrorToView = onFailUpdateView
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
        collectionLbl3.text = collections[2].title
        collectionLbl4.text = collections[3].title
        imgCollection1.sd_setImage(with: URL(string: collections[4].image?.src ?? ""), placeholderImage: UIImage(named: "pic"))
        imgCollection2.sd_setImage(with: URL(string: collections[1].image?.src ?? ""), placeholderImage: UIImage(named: "pic"))
        imgCollection3.sd_setImage(with: URL(string: collections[2].image?.src ?? ""), placeholderImage: UIImage(named: "pic"))
        imgCollection4.sd_setImage(with: URL(string: collections[3].image?.src ?? ""), placeholderImage: UIImage(named: "pic"))
        
    }
    func onSuccessAddsUpdateView (){
        guard let adds = shopViewModel.adds
            else{
                print("no adds")
                return
        }
        self.adds = adds
        print(adds[0].code)
    }
    
    func onFailUpdateView() {
        let alert = UIAlertController(title: "Error", message: shopViewModel.showError, preferredStyle: .alert)
        
        let okAction  = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            
        }
        
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    

    @IBAction func favoriteAction(_ sender: Any) {
    }
    
    @IBAction func adsAction(_ sender: Any) {
    }
    
    @IBAction func homeAction(_ sender: Any) {
        print("home action")
        let productList = ProductListViewController()
        if collections.count != 0 {
            productList.collectionID = collections[4]
            prepare(for: UIStoryboardSegue(identifier: "productList", source: self, destination: productList), sender: self)
            performSegue(withIdentifier: "productList", sender: self)
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        
        if segue.identifier == "col1" {
            let vc = segue.destination as! ProductListViewController
            vc.collectionID = (collections[4])
        }
        else if segue.identifier == "col2"{
            let vc = segue.destination as! ProductListViewController
            vc.collectionID = (collections[1])
            
        }else if segue.identifier == "col3" {
            let vc = segue.destination as! ProductListViewController
            vc.collectionID = collections[2]
        }else if segue.identifier == "col4"{
            let vc = segue.destination as! ProductListViewController
            vc.collectionID = collections[3]
            
        }
        
        
    }
    
    
    
    @IBAction func menAction(_ sender: Any) {
        //collectionLbl2
        let productList = ProductListViewController()
        if collections.count != 0 {
        productList.collectionID = collections[1]
        prepare(for: UIStoryboardSegue(identifier: "kids", source: self, destination: productList), sender: self)
        performSegue(withIdentifier: "kids", sender: self)
        }
    }
    
    @IBAction func womenAction(_ sender: Any) {
        //collectionLbl3
        
        let productList = ProductListViewController()
        if collections.count != 0 {
        productList.collectionID = collections[2]
        prepare(for: UIStoryboardSegue(identifier: "colection3", source: self, destination: productList), sender: self)
        performSegue(withIdentifier: "colection3", sender: self)
        }
    }
    
    @IBAction func kidsAction(_ sender: Any) {
        //collectionLbl4
        
        let productList = ProductListViewController()
        if collections.count != 0 {
        productList.collectionID = collections[3]
        prepare(for: UIStoryboardSegue(identifier: "colection4", source: self, destination: productList), sender: self)
        performSegue(withIdentifier:"colection4",sender: self)
        }
        
    }
}


extension ShopViewController:UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        collections = shopViewModel.searchProduct(sProducts: collections, searchTxt: searchText)
        
        //    collectionLbl1.text = collections[0].title
        
        
    }
    
    
}
