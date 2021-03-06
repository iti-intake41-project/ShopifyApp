//
//  ShopViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 5/22/21.
//

import UIKit

class ShopViewController: UIViewController{
    
    @IBOutlet weak var adsImage: UIImageView!
    @IBOutlet weak var vendorView: UIView!
    @IBOutlet weak var vendorCollectionView: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var products: [Product] = [Product]()
    var collections = [CustomCollections]()
    var adds: [DiscountCode] = [DiscountCode]()
    let shopViewModel: ShopViewModel = ShopViewModel()
    var shoppingViewModel: ShoppingBagViewModel!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var adsNum = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        //style()
        
        loading.startAnimating()
        // Do any additional setup after loading the view.
         //    productSearchBar.delegate = self
        shopViewModel.fetchSmartCollection()
        shopViewModel.bindsmartCollectionsViewModelToView = onSuccessUpdateView
        
        shopViewModel.fetchAdds()
        shopViewModel.bindAddsViewModelToView = onSuccessAddsUpdateView
        shopViewModel.bindViewModelErrorToView = onFailUpdateView
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(adsSwitcher), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        style()
        
        if !ConnectionViewModel.isConnected(){
            showAlert(view: self)
        }
    }
    
    @objc func adsSwitcher() {
        adsImage.image = UIImage(named: "ad\(adsNum)")
        
        if adsNum == 1 {
            adsNum = 2
        }else{
            adsNum = 1
        }
    }
    
    func onSuccessUpdateView() {
        guard let collections = shopViewModel.smartCollections else {
            print("no collections")
            return
        }
        self.collections = collections
        self.loading.stopAnimating()
        self.vendorCollectionView.reloadData()
        for i in collections {
            print(i.title)
        }
        
    }
    func onFailUpdateView() {
        let alert = UIAlertController(title: "Error", message: shopViewModel.showError, preferredStyle: .alert)
        
        let okAction  = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            
        }
        
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
    
    @IBAction func searchAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ProductList", bundle: nil)
        let productListViewController = storyboard.instantiateViewController(withIdentifier: "productList") as! ProductListViewController
//        productListViewController.collectionID = collections[indexPath.row]
        navigationController?.pushViewController(productListViewController, animated: true)
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
    
    @IBAction func addsAction(_ sender: Any) {
        if adds.count != 0 {
            UIPasteboard.general.string = adds[0].code
            
            let alert = UIAlertController(title: "Done", message: "Discount code copied", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
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
}
extension ShopViewController {
    
    func style() {
        adsImage.layer.cornerRadius = adsImage.frame.height / 14
        adsImage.layer.borderWidth = 1
        
        vendorView.layer.cornerRadius = vendorView.frame.height / 14
        vendorView.layer.borderWidth = 1
        vendorView.layer.borderColor = CGColor(srgbRed: 96/255, green: 72/255, blue: 116/255, alpha: 1)
        
        tabBarController?.tabBar.items![0].image = UIImage(systemName: "homekit")
        tabBarController?.tabBar.items![0].title = "Home"
        
        if shoppingViewModel.getShoppingCartProductList().count != 0 {
            tabBarController?.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favoriteAction(_:))),  UIBarButtonItem(image: UIImage(systemName: "cart.badge.plus.fill"), style: .plain, target: self, action: #selector(shoppingBagAction(_:)))]
        }else{
            tabBarController?.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favoriteAction(_:))),  UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: self, action: #selector(shoppingBagAction(_:)))]
        }
        
        tabBarController?.navigationItem.rightBarButtonItems![0].tintColor = .white
        tabBarController?.navigationItem.rightBarButtonItems![1].tintColor = .white
        tabBarController?.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchAction(_:)))
        tabBarController?.navigationItem.leftBarButtonItems![0].tintColor = .white
        tabBarController?.navigationItem.title = "Home"
        tabBarController?.navigationItem.backBarButtonItem?.tintColor = .white
    }
}

extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let vendor = collectionView.dequeueReusableCell(withReuseIdentifier: "vendor", for: indexPath) as! VendorCollectionViewCell
        
        vendor.imageWidth.constant = (collectionView.frame.width / 2) - 10
        vendor.imageHeight.constant = (collectionView.frame.height / 2) - 35
        
        //   vendor.image.image = UIImage(named: "pic")
        vendor.image.sd_setImage(with: URL(string: collections[indexPath.row].image?.src ?? ""), placeholderImage: UIImage(named: "noImage"))
        vendor.image.layer.borderWidth = 1
        vendor.image.layer.cornerRadius = vendor.image.frame.height / 12
        vendor.image.layer.borderColor = CGColor(srgbRed: 96/255, green: 72/255, blue: 116/255, alpha: 1)
        
        //     vendor.name.text = "\(indexPath.row)"
        vendor.name.text = collections[indexPath.row].title
        
        return vendor
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        let storyboard = UIStoryboard(name: "ProductList", bundle: nil)
        let productListViewController = storyboard.instantiateViewController(withIdentifier: "productList") as! ProductListViewController
    //    productListViewController.modalPresentationStyle = .fullScreen
        productListViewController.collectionID = collections[indexPath.row]
        //present(productListViewController, animated: true, completion: nil)
        navigationController?.pushViewController(productListViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: (collectionView.frame.height / 2) - 30)
    }
}
