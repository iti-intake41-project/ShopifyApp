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
    
    
}
extension ShopViewController:UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        collections = shopViewModel.searchProduct(sProducts: collections, searchTxt: searchText)
        
        //    collectionLbl1.text = collections[0].title
        
        
    }
    
    
    
    
    
}
