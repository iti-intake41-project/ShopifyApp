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
    @IBOutlet weak var sliderLbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderView: UIStackView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var products: [Product] = [Product]()
    var orignalProducts: [Product] = [Product]()
    let productsViewModel: ProductListViewModel = ProductListViewModel()
    var collectionID:CustomCollections?
    //Moataz
    var favouritesViewModel:FavouriteViewModelTemp!
    var favourites: [Product] = [Product]()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var settingVm = SettingViewModel()
    //Moataz

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productSearchView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
 
        
        productsViewModel.bindProductListViewModelToView = onSuccessUpdateView
        productsViewModel.bindViewModelErrorToView = onFailUpdateView
        //call  products from viewController based on collectionID
        print(collectionID?.id ?? "dkcdj")
        print(collectionID?.title ?? "wdkof")
    
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
        guard let collectionID = collectionID else {
            //alert
            return
            
        }
        productsViewModel.fetchAllProductsFromAPI(collectionID: "\(collectionID.id)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sliderView.isHidden = true
        products = orignalProducts
    }

    @IBAction func sliderAction(_ sender: UISlider) {
        sliderLbl.text = "Price: " + String(Int(sender.value))
        products = orignalProducts.filter{Double($0.varients![0].price)! <= Double(sender.value) }
               print(String(Int(sender.value)))
               self.productsCollectionView.reloadData()
               
    }

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
    
    @IBAction func sortAction(_ sender: Any) {
        products = orignalProducts.sorted(by: {
            Double ($0.varients![0].price)! < Double( $1.varients![0].price)!
            
        })
        self.productsCollectionView.reloadData()
    }
    
    @IBAction func filterAction(_ sender: Any) {
        sliderView.isHidden = !sliderView.isHidden
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  productsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        cell.imageWidth.constant = (collectionView.frame.width / 2) - 10
        cell.imageHeight.constant = (collectionView.frame.height / 2) - 40
        
        cell.productImage.sd_setImage(with: URL(string:products[indexPath.row].images[0].src), placeholderImage: UIImage(named: "noImage"))
        cell.productImage.layer.borderWidth = 1
        cell.productImage.layer.cornerRadius = cell.productImage.frame.height / 12
        cell.productImage.layer.borderColor = CGColor(srgbRed: 96/255, green: 72/255, blue: 116/255, alpha: 1)

        var price = products[indexPath.row].varients?[0].price

          price =  FormatePrice.formatePrice(priceStr: price)
      
            cell.priceLbl.text = " \(price!)"

       
        //Moataz
//        cell.favouriteBtn.backgroundColor = UIColor.white
        cell.product = products[indexPath.row]
        if favouritesViewModel.isFavourite(id: products[indexPath.row].varients![0].id) {
            cell.favouriteBtn.tintColor = .red
        }else{
            cell.favouriteBtn.tintColor = .gray
        }
//        cell.isFavourite = favouritesViewModel.isFavourite(id: products[indexPath.row].id)
        cell.delegate = self
        //Moataz
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
//        productDetailsViewController.modalPresentationStyle = .fullScreen
        productDetailsViewController.product = products[indexPath.row]
        navigationController?.pushViewController(productDetailsViewController, animated: true)
//        present(productDetailsViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: (collectionView.frame.height / 2) - 35)
    }
}


extension ProductListViewController:UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        products = productsViewModel.searchProduct(sProducts: orignalProducts, searchTxt: searchText)
        self.productsCollectionView.reloadData()
        
        if products.count == 0 {
            let imageView = UIImageView(image: UIImage(named: "noSearch"))
            imageView.contentMode = .scaleAspectFill
            productsCollectionView.backgroundView = imageView
        }else{
            productsCollectionView.backgroundView = nil
        }
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
        print("is favourite controller: \(id)")

        return favouritesViewModel.isFavourite(id: id)
    }
}

//Moataz
