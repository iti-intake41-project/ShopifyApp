//
//  ProductListViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/2/21.
//

import UIKit
import SDWebImage

class ProductListViewController: UIViewController {

    @IBOutlet weak var productSearchView: UISearchBar!

    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var sliderLbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    var products: [Product] = [Product]()
    var orignalProducts: [Product] = [Product]()
    let productsViewModel: ProductListViewModel = ProductListViewModel()
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productSearchView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
        productsViewModel.fetchAllProductsFromAPI()

        productsViewModel.bindProductListViewModelToView = onSuccessUpdateView
        productsViewModel.bindViewModelErrorToView = onFailUpdateView
        //call  products from viewController based on collectionID
      

               
        
    }
    override func viewWillAppear(_ animated: Bool) {
    }

    @IBAction func sliderAction(_ sender: UISlider) {
        sliderLbl.text = String(Int(sender.value))
        products = orignalProducts.filter{Double($0.varients![0].price)! <= Double(sender.value) }
               print(String(Int(sender.value)))
               self.productsCollectionView.reloadData()
               
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
        self.orignalProducts = products
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
    
    @IBAction func sortProducts(_ sender: UIButton) {
        
   
        products = orignalProducts.sorted(by: {
            Double ($0.varients![0].price)! < Double( $1.varients![0].price)!
            
        })
        self.productsCollectionView.reloadData()
        
    }
    
}
extension ProductListViewController : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width-20 , height:200)
//    }
   
    
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

        cell.priceLbl.text = products[indexPath.row].varients?[0].price
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("dkifcj")
    }
    
}

extension ProductListViewController:UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        products = productsViewModel.searchProduct(sProducts: orignalProducts, searchTxt: searchText)
        self.productsCollectionView.reloadData()
    }
    
    
    
                 
     
}
