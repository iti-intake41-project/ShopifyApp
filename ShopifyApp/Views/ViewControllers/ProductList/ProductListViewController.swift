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

    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    var products: [Product] = [Product]()
    var orignalProducts: [Product] = [Product]()
    let productsViewModel: ProductListViewModel = ProductListViewModel()
    //Moataz
    var favouritesViewModel:FavouriteViewModelTemp!
    var favourites: [Product] = [Product]()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    //Moataz
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
      

        //Moataz
        favouritesViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        favouritesViewModel.bindFavouritesList = { [weak self] in
            self?.favourites = self?.favouritesViewModel.favourites ?? []
//            self?.productsCollectionView.reloadData()
        }
        favourites = favouritesViewModel.favourites
        //Moataz
        
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
        
   
        products = products.sorted(by: {
            Double ($0.varients![0].price)! < Double( $1.varients![0].price)!
            
        })
        self.productsCollectionView.reloadData()
        
    }
    
}
extension ProductListViewController : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2)-10 , height:200)
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

        cell.priceLbl.text = products[indexPath.row].varients?[0].price
        
        //Moataz
        cell.favouriteBtn.backgroundColor = UIColor.white
        cell.product = products[indexPath.row]
        cell.isFavourite = favouritesViewModel.isFavourite(id: products[indexPath.row].id)
        cell.delegate = self
        //Moataz
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.modalPresentationStyle = .fullScreen
        productDetailsViewController.product = products[indexPath.row]
        present(productDetailsViewController, animated: true, completion: nil)
    }
    
}

extension ProductListViewController:UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        products = productsViewModel.searchProduct(sProducts: orignalProducts, searchTxt: searchText)
        self.productsCollectionView.reloadData()
    }
    
    
    
                 
     
}


//Moataz

extension ProductListViewController: FavouriteProductCellProtocol {
    func deleteFavourite(id: Int) {
        favouritesViewModel.deleteFavourite(id: id)
    }
    
    func addFavourite(product: Product) {
        favouritesViewModel.addFavourite(product: product)
    }
    
    func isFavourite(id: Int) -> Bool {
        return favouritesViewModel.isFavourite(id: id)
    }
}

//Moataz
