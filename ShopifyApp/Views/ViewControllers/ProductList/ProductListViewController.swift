//
//  ProductListViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/2/21.
//

import UIKit
import SDWebImage

class ProductListViewController: UIViewController {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    var products: [Product] = [Product]()
    let productsViewModel: ProductListViewModel = ProductListViewModel()
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
        productsViewModel.fetchAllProductsFromAPI()

        productsViewModel.bindProductListViewModelToView = onSuccessUpdateView
        productsViewModel.bindViewModelErrorToView = onFailUpdateView
        //call  products from viewController based on collectionID
      

               
        
    }
    override func viewWillAppear(_ animated: Bool) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
    func onSuccessUpdateView() {
          guard let products = productsViewModel.allProducts
           else {
            print("no products")
            return
            
        }
            self.products = products

        productsCollectionView.reloadData()
        print("****ProductList****")
            print(products.count)
            print(products[0].title)
    //        print(products[0].productType!)
            print("-------------------------")
        }
        func onFailUpdateView() {
            let alert = UIAlertController(title: "Error", message: productsViewModel.showError, preferredStyle: .alert)
                 
                 let okAction  = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                     
                     
                 }
                 
                 
                 alert.addAction(okAction)
                 self.present(alert, animated: true, completion: nil)
        }
    
    
}
extension ProductListViewController : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-20 , height:200)
    }
   
    
}
extension ProductListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  productsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        
        cell.productImage.sd_setImage(with: URL(string:products[indexPath.row].images[0].src), placeholderImage: UIImage(named: "noImage"))

        cell.priceLbl.text = products[indexPath.row].title
        cell.priceLbl.text = products[indexPath.row].varients?[0].price
        
        return cell
        
    }
    
    
}
