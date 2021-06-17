//
//  FavouritesCollectionViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 08/06/2021.
//

import UIKit

class FavouritesCollectionViewController: UICollectionViewController {

    var favourites: [Product] = [Product]()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var viewModel:FavouriteViewModelTemp!
    var productDetail: Product!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        viewModel.bindFavouritesList = { [weak self] in
            self?.favourites = self?.viewModel.favourites ?? []
            self?.collectionView.reloadData()
        }
        favourites = viewModel.favourites

//        viewModel.addFavourite(product: Product(id: 12, title: "shoes15", description: "", vendor: nil, productType: nil, images: [ProductImage(id: 0, productID: 0, position: 0, width: 0, height: 0, src: "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/6eb0aa9fdb271e5954b2f0d09a0640e4.jpg?v=1621288163", graphQlID: "")], options: nil, varients: [Varient(id: 0, productID: 0, title: "", price: "29.00")]))
//        viewModel.addFavourite(product: Product(id: 16, title: "shoes15", description: "", vendor: nil, productType: nil, images: [ProductImage(id: 0, productID: 0, position: 0, width: 0, height: 0, src: "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/6eb0aa9fdb271e5954b2f0d09a0640e4.jpg?v=1621288163", graphQlID: "")], options: nil, varients: [Varient(id: 0, productID: 0, title: "", price: "15")]))
//        viewModel.addFavourite(product: Product(id: 18, title: "shoes15", description: "", vendor: nil, productType: nil, images: [ProductImage(id: 0, productID: 0, position: 0, width: 0, height: 0, src: "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/6eb0aa9fdb271e5954b2f0d09a0640e4.jpg?v=1621288163", graphQlID: "")], options: nil, varients: [Varient(id: 0, productID: 0, title: "", price: "10")]))
//        viewModel.addFavourite(product: Product(id: 17, title: "shoes15", description: "", vendor: nil, productType: nil, images: [ProductImage(id: 0, productID: 0, position: 0, width: 0, height: 0, src: "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/6eb0aa9fdb271e5954b2f0d09a0640e4.jpg?v=1621288163", graphQlID: "")], options: nil, varients: [Varient(id: 0, productID: 0, title: "", price: "9.99")]))
    }
    override func viewWillAppear(_ animated: Bool) {
        if !ConnectionViewModel.isConnected(){
            showAlert(view: self)
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourites.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        
        cell.imageWidth.constant = (collectionView.frame.width / 2) - 10
        cell.imageHeight.constant = (collectionView.frame.height / 2) - 40
        
        cell.productImage.sd_setImage(with: URL(string:favourites[indexPath.row].images[0].src), placeholderImage: UIImage(named: "noImage"))
        cell.productImage.layer.borderWidth = 1
        cell.productImage.layer.cornerRadius = cell.productImage.frame.height / 12

        cell.priceLbl.text = favourites[indexPath.row].varients?[0].price
        cell.favouriteBtn.backgroundColor = UIColor.white
        cell.isFavourite = viewModel.isFavourite(id: favourites[indexPath.row].id)
        cell.product = favourites[indexPath.row]
        cell.delegate = self
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        productDetail = favourites[indexPath.row]
        performSegue(withIdentifier: "navigateToProductDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToProductDetails" {
            let navController = segue.destination as! ProductDetailsViewController
            navController.product = productDetail
        }
    }

}

extension FavouritesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: (collectionView.frame.height / 2) - 35)
    }
}

extension FavouritesCollectionViewController: FavouriteProductCellProtocol {
    
    func deleteFavourite(id: Int) {
        viewModel.deleteFavourite(id: id)
//        let alert = UIAlertController(title: "Remove Product", message: "Are you sure you want to remove this product from your favourite list?", preferredStyle: .alert)
//        let yesAction = UIAlertAction(title: "YES", style: .default) { [weak self] (action) in
//            self?.viewModel.deleteFavourite(id: id)
//        }
//        let noAction = UIAlertAction(title: "NO", style: .default)
//        alert.addAction(yesAction)
//        alert.addAction(noAction)
//        self.present(alert, animated: true, completion: nil)
//        collectionView.reloadData()
    }
    
    func addFavourite(product: Product) {
        viewModel.addFavourite(product: product)
    }
    
    func isFavourite(id: Int) -> Bool {
        return viewModel.isFavourite(id: id)
    }
}
