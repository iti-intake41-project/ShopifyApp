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
        prepareView()
    }
    
    func prepareView(){
        navigationItem.title = "Favourites"
        viewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        viewModel.bindFavouritesList = { [weak self] in
            self?.favourites = self?.viewModel.favourites ?? []
            self?.collectionView.reloadData()
            
            if self!.favourites.count == 0 {
                let imageView = UIImageView(image: UIImage(named: "emptyFav"))
                imageView.contentMode = .scaleAspectFill
                self!.collectionView.backgroundView = imageView
            }else{
                self!.collectionView.backgroundView = nil
            }
        }
        favourites = viewModel.favourites
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
    }
    
    func addFavourite(product: Product) {
        viewModel.addFavourite(product: product)
    }
    
    func isFavourite(id: Int) -> Bool {
        return viewModel.isFavourite(id: id)
    }
}
