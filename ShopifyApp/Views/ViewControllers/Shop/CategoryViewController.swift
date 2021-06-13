//
//  CategoryViewController.swift
//  ShopifyApp
//
//  Created by Asmaa Mohamed on 04/06/2021.
//

import UIKit
import SDWebImage

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var productSearchBar: UISearchBar!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var subCategoriesTable: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var item1: UIBarButtonItem!
    @IBOutlet weak var item2: UIBarButtonItem!
    @IBOutlet weak var item3: UIBarButtonItem!
    @IBOutlet weak var item4: UIBarButtonItem!
    
    var products = [Product]()
    let shopViewModel = ShopViewModel()
    var collections = [CustomCollections]()
    var product:Product!
    var toolBarItem = 4
    var subCategory:String = "SHOES"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopViewModel.fetchCustomCollection()
        shopViewModel.bindCategoryViewModelToView = onSuccessUpdateView
    }
    override func viewWillAppear(_ animated: Bool) {
        
        shopFilteredProducts(toolBarItem: toolBarItem, subCategory: subCategory)
    }
    @IBAction func item1(_ sender: Any) {
        toolBarItem = 4
        toolBar.items![0].tintColor = .black
        shopFilteredProducts(toolBarItem: toolBarItem, subCategory: subCategory)
        
    }
    
    @IBAction func item2(_ sender: Any) {
        toolBarItem = 1
        shopFilteredProducts(toolBarItem: toolBarItem, subCategory: subCategory)
        
    }
    @IBAction func item3(_ sender: Any) {
        toolBarItem = 2
        shopFilteredProducts(toolBarItem: toolBarItem, subCategory: subCategory)
    }
    @IBAction func item4(_ sender: Any) {
        toolBarItem = 3
        shopFilteredProducts(toolBarItem: toolBarItem, subCategory: subCategory)
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
}



extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCategoryCell", for: indexPath) as! SubCategoriesCell
        
        switch indexPath.section {
        case 0:
            cell.title.text = "SHOES"
            break
        case 1:
            cell.title.text = "T-SHIRTS"
            break
        case 2:
            cell.title.text = "3"
            break
        case 3:
            cell.title.text = "ACCESSORIES"
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // call function
            subCategory = "SHOES"
            shopFilteredProducts(toolBarItem: toolBarItem, subCategory: "SHOES")
            break
        case 1:
            subCategory =  "T-SHIRTS"
            shopFilteredProducts(toolBarItem: toolBarItem, subCategory: "T-SHIRTS")
            break
        case 2:
            subCategory = "SHOES"
            shopFilteredProducts(toolBarItem: toolBarItem, subCategory: "SHOES")
            break
        case 3:
            subCategory = "ACCESSORIES"
            shopFilteredProducts(toolBarItem: toolBarItem, subCategory: "ACCESSORIES")
            break
        default:
            break
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! CategoryProductsCollectionView
        
        item.image.sd_setImage(with: URL(string: products[indexPath.row].images[0].src), placeholderImage: UIImage(named: "noImage"))
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        product = products[indexPath.row]
        print(product.title)
        performSegue(withIdentifier: "ProductDetailsViewController", sender: self)
    }
}
//donia
extension CategoryViewController {
    func onSuccessUpdateView() {
        guard let collections = shopViewModel.customCollections else {
            print("no collections")
            return
        }
        self.collections = collections
        for i in collections {
            print(i.title)
        }
        print(collections.count)
        // set toolbar
        item1.title = collections[4].title
        item2.title = collections[1].title
        item3.title = collections[2].title
        item4.title = collections[3].title
        
        
    }
    func onSucessProductsUpdateView(){
        guard let products = shopViewModel.allProducts else {
            print("no products")
            return
        }
        self.products = products
        self.products = filterProducts(products: products, subCategory: subCategory)
        categoriesCollectionView.reloadData()
        print(" success products")
    }
    
    func filterProducts(products:[Product],subCategory:String) -> [Product] {
        return products.filter{
            ($0.productType == subCategory)
            
        }
        
    }
    func shopFilteredProducts(toolBarItem:Int,subCategory:String){
        print("shopFilteredProducts")
        if  collections.count != 0  {
            print(toolBarItem)
            shopViewModel.fetchAllProductsFromAPI(collectionID: "\(collections[toolBarItem].id)")
            shopViewModel.bindShopViewModelToView = onSucessProductsUpdateView
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetailsViewController"{
            let vc = segue.destination as! ProductDetailsViewController
            vc.product = product
        }
    }
    
}
//donia
