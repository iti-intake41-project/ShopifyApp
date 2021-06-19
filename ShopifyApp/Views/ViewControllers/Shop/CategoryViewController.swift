//
//  CategoryViewController.swift
//  ShopifyApp
//
//  Created by Asmaa Mohamed on 04/06/2021.
//

import UIKit
import SDWebImage
import JJFloatingActionButton

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var productSearchBar: UISearchBar!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
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
    var actionButton = JJFloatingActionButton()
    
    var favouritesViewModel:FavouriteViewModelTemp!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopViewModel.fetchCustomCollection()
        shopViewModel.bindCategoryViewModelToView = onSuccessUpdateView
        
        favouritesViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        
        createFloatingButton()
    }
    override func viewWillAppear(_ animated: Bool) {
         if !ConnectionViewModel.isConnected(){
                   showAlert(view: self)
               }
    }
    override func viewDidAppear(_ animated: Bool) {
        if !ConnectionViewModel.isConnected(){
                          showAlert(view: self)
                      }
        toolBar.items![0].tintColor = UIColor(named: "mainColor")
        shopFilteredProducts(toolBarItem: toolBarItem, subCategory: subCategory)
        
        
        tabBarController?.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favoriteAction(_:))),  UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: self, action: #selector(shoppingBagAction(_:)))]
        tabBarController?.navigationItem.rightBarButtonItems![0].tintColor = .white
        tabBarController?.navigationItem.rightBarButtonItems![1].tintColor = .white
        tabBarController?.navigationItem.leftBarButtonItems = []
        tabBarController?.navigationItem.title = "Category"
        tabBarController?.navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    @IBAction func item1(_ sender: Any) {
        
        toolBarItem = 4
        shopFilteredProducts(toolBarItem: toolBarItem, subCategory: subCategory)
        
        print("1")
        item1.tintColor = UIColor(named: "mainColor")
        item2.tintColor = .link
        item3.tintColor = .link
        item4.tintColor = .link
    }
    
    @IBAction func item2(_ sender: Any) {
        toolBarItem = 1
        shopFilteredProducts(toolBarItem: toolBarItem, subCategory: subCategory)
        
        print("2")

        item1.tintColor = .link
        item2.tintColor = UIColor(named: "mainColor")
        item3.tintColor = .link
        item4.tintColor = .link
    }
    @IBAction func item3(_ sender: Any) {
        toolBarItem = 2
        shopFilteredProducts(toolBarItem: toolBarItem, subCategory: subCategory)
        
        print("3")

        item1.tintColor = .link
        item2.tintColor = .link
        item3.tintColor = UIColor(named: "mainColor")
        item4.tintColor = .link
    }
    @IBAction func item4(_ sender: Any) {
        toolBarItem = 3
        shopFilteredProducts(toolBarItem: toolBarItem, subCategory: subCategory)
        
        print("4")

        item1.tintColor = .link
        item2.tintColor = .link
        item3.tintColor = .link
        item4.tintColor = UIColor(named: "mainColor")
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



extension CategoryViewController {
    func createFloatingButton() {
        actionButton.addItem(title: "", image: UIImage(named: "sneakers")?.withRenderingMode(.alwaysOriginal)) { item in
            self.subCategory = "SHOES"
            self.shopFilteredProducts(toolBarItem: self.toolBarItem, subCategory: "SHOES")
            self.actionButton.buttonImage = UIImage(named: "sneakers")
        }

        actionButton.addItem(title: "", image: UIImage(named: "shirt")?.withRenderingMode(.alwaysOriginal)) { item in
            self.subCategory =  "T-SHIRTS"
            self.shopFilteredProducts(toolBarItem: self.toolBarItem, subCategory: "T-SHIRTS")
            self.actionButton.buttonImage = UIImage(named: "shirt")
        }
        
        actionButton.addItem(title: "", image: UIImage(named: "wedding-rings")?.withRenderingMode(.alwaysOriginal)) { item in
            self.subCategory =  "ACCESSORIES"
            self.shopFilteredProducts(toolBarItem: self.toolBarItem, subCategory: "ACCESSORIES")
            self.actionButton.buttonImage = UIImage(named: "wedding-rings")
        }

//        view.addSubview(actionButton)
//        actionButton.translatesAutoresizingMaskIntoConstraints = false
//        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
//        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

        // last 4 lines can be replaced with
         actionButton.display(inViewController: self)

        floatingConfigration()
    }
    
    func floatingConfigration() {
        actionButton.handleSingleActionDirectly = false
        actionButton.buttonDiameter = 50
        actionButton.overlayView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        actionButton.buttonImage = UIImage(named: "sneakers")
        actionButton.buttonColor = UIColor(named: "mainColor")!
        actionButton.buttonImageColor = .white
        actionButton.buttonImageSize = CGSize(width: 20, height: 20)

        actionButton.buttonAnimationConfiguration = .transition(toImage: UIImage(named: "cancel")!)
        actionButton.itemAnimationConfiguration = .slideIn(withInterItemSpacing: 14)

        actionButton.layer.shadowColor = UIColor.black.cgColor
        actionButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        actionButton.layer.shadowOpacity = Float(0.4)
        actionButton.layer.shadowRadius = CGFloat(2)

        actionButton.itemSizeRatio = CGFloat(0.75)
        actionButton.configureDefaultItem { item in
            item.titlePosition = .trailing

            item.titleLabel.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
            item.titleLabel.textColor = .white
            item.buttonColor = .white
            item.imageSize = CGSize(width: 15, height: 15)
            item.buttonImageColor = .black

            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.shadowOffset = CGSize(width: 0, height: 1)
            item.layer.shadowOpacity = Float(0.4)
            item.layer.shadowRadius = CGFloat(2)
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        
        item.imageWidth.constant = (collectionView.frame.width / 3) - 15
        item.imageHeight.constant = (collectionView.frame.height / 4) - 30
        
        item.productImage.sd_setImage(with: URL(string: products[indexPath.row].images[0].src), placeholderImage: UIImage(named: "noImage"))
        item.productImage.layer.borderWidth = 1
        item.productImage.layer.borderColor = CGColor(srgbRed: 96/255, green: 72/255, blue: 116/255, alpha: 1)
        item.productImage.layer.cornerRadius = item.productImage.frame.height / 12
        
        item.priceLbl.text = FormatePrice.formatePrice(priceStr: "\(products[indexPath.row].varients![0].price)")
        
        item.product = products[indexPath.row]
        if favouritesViewModel.isFavourite(id: products[indexPath.row].varients![0].id) {
            item.favouriteBtn.tintColor = .red
        }else{
            item.favouriteBtn.tintColor = .gray
        }
        
        item.delegate = self
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        product = products[indexPath.row]
        print(product.title)
        performSegue(withIdentifier: "ProductDetailsViewController", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 3), height: (collectionView.frame.height / 4))
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

extension CategoryViewController: FavouriteProductCellProtocol {
    func deleteFavourite(id: Int) {
        favouritesViewModel.deleteFavourite(id: id)
    }
    
    func addFavourite(product: Product) {
        favouritesViewModel.addFavourite(product: product)
    }
    
    func isFavourite(id: Int) -> Bool {
        print("is favourite controller: \(id)")

        return favouritesViewModel.isFavourite(id: id)
    }
}
