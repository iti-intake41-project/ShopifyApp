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
    
    var products: [Product] = [Product]()
    var collections = [CustomCollections]()
    let shopViewModel: ShopViewModel = ShopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()

        shopViewModel.fetchCustomCollection()
        shopViewModel.bindShopViewModelToView = onSuccessUpdateView
        // Do any additional setup after loading the view.
   //     productSearchBar.delegate = self
     //   shopViewModel.fetchSmartCollection()
   //     shopViewModel.bindsmartCollectionsViewModelToView = onSuccessUpdateView
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
//        collectionLbl1.text = collections[4].title
//        collectionLbl2.text = collections[1].title
//        collectionLbl3.text = collections[3].title
//        collectionLbl4.text = collections[2].title
//        collectionImg1.sd_setImage(with: URL(string: collections[4].image?.src ?? ""), placeholderImage: UIImage(named: "noImage"))
//        collectionImg2.sd_setImage(with: URL(string: collections[1].image?.src ?? ""), placeholderImage: UIImage(named: "noImage"))
//        collectionImg3.sd_setImage(with: URL(string: collections[2].image?.src ?? ""), placeholderImage: UIImage(named: "noImage"))
//        collectionImg4.sd_setImage(with: URL(string: collections[3].image?.src ?? ""), placeholderImage: UIImage(named: "noImage"))
        
    }
    func onFailUpdateView() {
        let alert = UIAlertController(title: "Error", message: shopViewModel.showError, preferredStyle: .alert)
        
        let okAction  = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            
        }
        
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
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
    }
}

extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let vendor = collectionView.dequeueReusableCell(withReuseIdentifier: "vendor", for: indexPath) as! VendorCollectionViewCell
        
        vendor.imageWidth.constant = (collectionView.frame.width / 2) - 10
        vendor.imageHeight.constant = (collectionView.frame.height / 2) - 35
        
        vendor.image.image = UIImage(named: "pic")
        vendor.image.layer.borderWidth = 1
        vendor.image.layer.cornerRadius = vendor.image.frame.height / 12
        
        vendor.name.text = "\(indexPath.row)"

        return vendor
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: (collectionView.frame.height / 2) - 30)
    }
}
