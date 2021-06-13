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
    
    // var products: [Product]!
    //doina
    var products = [Product]()
    let shopViewModel = ShopViewModel()
    var collections = [CustomCollections]()
    var product:Product!
    var toolBarItem :Int = 4
    var subCategoryIndex:String = "SHOES"
    //doina
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        toolBar.items![0].action = #selector(homeTabAction)
        toolBar.items![1].action = #selector(womenTabAction)
        toolBar.items![2].action = #selector(menTabAction)
        toolBar.items![3].action = #selector(kidsTabAction)
        //toolBar.items![0].tintColor = .black
        //donia
        shopViewModel.fetchCustomCollection()
        shopViewModel.bindCategoryViewModelToView = onSuccessUpdateView
        //donia
    }
    
    
    @IBAction func item4(_ sender: Any) {
        
        print("vkoinjd")
        toolBarItem = 3
               toolBar.items![3].tintColor = .darkGray
               toolBar.items![1].tintColor = .blue
               toolBar.items![0].tintColor = .blue
               toolBar.items![2].tintColor = .blue
               shopViewModel.fetchAllProductsFromAPI(collectionID: "\(collections[toolBarItem].id)")
               self.products = filterProducts(products: products, subCategory: subCategoryIndex)
               categoriesCollectionView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    @objc func homeTabAction() {
        toolBarItem = 4
        toolBar.items![0].tintColor = .darkGray
        toolBar.items![1].tintColor = .blue
        toolBar.items![2].tintColor = .blue
        toolBar.items![3].tintColor = .blue
        shopViewModel.fetchAllProductsFromAPI(collectionID: "\(collections[toolBarItem].id)")
        self.products = filterProducts(products: products, subCategory: subCategoryIndex)
        categoriesCollectionView.reloadData()
        
        
    }
    
    @objc func womenTabAction() {
        
        toolBarItem = 1
        toolBar.items![1].tintColor = .darkGray
        toolBar.items![0].tintColor = .blue
        toolBar.items![2].tintColor = .blue
        toolBar.items![3].tintColor = .blue
        shopViewModel.fetchAllProductsFromAPI(collectionID: "\(collections[toolBarItem].id)")
        self.products = filterProducts(products: products, subCategory: subCategoryIndex)
        categoriesCollectionView.reloadData()
    }
    
    @objc func menTabAction() {
        
        toolBarItem = 2
        toolBar.items![2].tintColor = .darkGray
        toolBar.items![1].tintColor = .blue
        toolBar.items![0].tintColor = .blue
        toolBar.items![3].tintColor = .blue
        shopViewModel.fetchAllProductsFromAPI(collectionID: "\(collections[toolBarItem].id)")
        self.products = filterProducts(products: products, subCategory: subCategoryIndex)
        categoriesCollectionView.reloadData()
    }
    
    @objc func kidsTabAction() {
        toolBarItem = 3
        toolBar.items![3].tintColor = .darkGray
        toolBar.items![1].tintColor = .blue
        toolBar.items![0].tintColor = .blue
        toolBar.items![2].tintColor = .blue
        shopViewModel.fetchAllProductsFromAPI(collectionID: "\(collections[toolBarItem].id)")
        self.products = filterProducts(products: products, subCategory: subCategoryIndex)
        categoriesCollectionView.reloadData()
    }
    
    @IBAction func shoppingBagAction(_ sender: Any) {
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
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
            cell.title.text = "T-shirt"
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
            // get selected toolbar
            
            // call function
            subCategoryIndex = "SHOES"
            shopViewModel.fetchAllProductsFromAPI(collectionID: "\(collections[toolBarItem].id)")
            self.products = filterProducts(products: products, subCategory: "SHOES")
            categoriesCollectionView.reloadData()
            break
        case 1:
            //  subCategoryIndex = 0
            shopViewModel.fetchAllProductsFromAPI(collectionID: "\(collections[toolBarItem].id)")
            self.products = filterProducts(products: products, subCategory: "SHOES")
            categoriesCollectionView.reloadData()
            break
        case 2:
            //  subCategoryIndex = 0
            shopViewModel.fetchAllProductsFromAPI(collectionID: "\(collections[toolBarItem].id)")
            self.products = filterProducts(products: products, subCategory: "SHOES")
            categoriesCollectionView.reloadData()
            break
        case 3:
            subCategoryIndex = "ACCESSORIES"
            shopViewModel.fetchAllProductsFromAPI(collectionID: "\(collections[toolBarItem].id)")
            self.products = filterProducts(products: products, subCategory: "ACCESSORIES")
            categoriesCollectionView.reloadData()
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
        
        //        let images = products[indexPath.row].images
        //        item.image.sd_setImage(with: URL(string: images[0].src), completed: nil)
        //        item.image.image = UIImage(named: "pic1")
        //
        //donia
        item.image.sd_setImage(with: URL(string: products[indexPath.row].images[0].src), placeholderImage: UIImage(named: "pic"))
        //donia
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
        // set toolbar
        toolBar.items![0].title = collections[4].title
        toolBar.items![1].title = collections[1].title
        toolBar.items![2].title = collections[2].title
        toolBar.items![3].title = collections[3].title
        // set products based on collectionID and subCategory
        // move to subcategory item
        shopViewModel.fetchAllProductsFromAPI(collectionID: "\(collections[4].id)")
        shopViewModel.bindShopViewModelToView = onSucessProductsUpdateView
        
        
    }
    func onSucessProductsUpdateView(){
        guard let products = shopViewModel.allProducts else {
            print("no products")
            return
        }
        self.products = products
        self.products = filterProducts(products: products, subCategory: "SHOES")
        categoriesCollectionView.reloadData()
        print("ckiv")
    }
    
    func filterProducts(products:[Product],subCategory:String) -> [Product] {
        return products.filter{
            ($0.productType == subCategory)
            
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
