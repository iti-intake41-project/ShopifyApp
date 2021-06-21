//
//  ProductDetailsViewController.swift
//  ShopifyApp
//
//  Created by Abanob Wadie on 05/06/2021.
//

import UIKit
import SDWebImage
import Cosmos

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productImagesCollectionView: UICollectionView!
    @IBOutlet weak var imageControl: UIPageControl!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    
    var product: Product!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var shoppingViewModel: ShoppingBagViewModel!
    var ratings = [4.0, 4.5, 5]
    var shopViewModel = ShopViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        
        style()
        setProductDetails()
    }
    @IBAction func favoriteAction(_ sender: Any) {
        if shopViewModel.isLoggedIn(){
            if favoriteButton.tintColor == .red{
                favoriteButton.tintColor = .gray
                shoppingViewModel.deleteFavourite(id: product.varients![0].id)
            }else {
                favoriteButton.tintColor = .red
                shoppingViewModel.addFavourite(product: product)
            }
        }else{
            performSegue(withIdentifier: "navToLogin", sender: self)
        }
    }
    
    @IBAction func cartAction(_ sender: Any) {
        if shopViewModel.isLoggedIn(){
            if shoppingViewModel.isInShopingCart(id: product.varients![0].id) {
                let alert = UIAlertController(title: "Done", message: "This product is already in your cart", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }))
                present(alert, animated: true, completion: nil)
            }else{
                shoppingViewModel.addProduct(product: product)
                navigationController?.popViewController(animated: true)
            }
        }else{
            performSegue(withIdentifier: "navToLogin", sender: self)
        }
    }
    
//    @IBAction func goBack(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }

}

extension ProductDetailsViewController {
    
    func style() {
        cartButton.layer.cornerRadius = cartButton.frame.height / 2
    }
    
    func setProductDetails() {
        navigationItem.title = product.vendor
        
        productNameLabel.text = product.title
        ratingView.settings.fillMode = .precise
        ratingView.rating = ratings.randomElement() ?? 4.5
        
        if let varients = product.varients {
            productPriceLabel.text = FormatePrice.formatePrice(priceStr: "\(varients[0].price)")
        }
        
        productDescriptionTextView.text = product.description
        descriptionHeight.constant = productDescriptionTextView.contentSize.height
        
        if shoppingViewModel.isFavourite(id: product.varients![0].id) {
            favoriteButton.tintColor = .red
        }else {
            favoriteButton.tintColor = .gray
        }
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageControl.numberOfPages = product.images.count
        return product.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! ProductDetailsCollectionViewCell
        
        let ImageSrc = product.images[indexPath.row].src
        image.productImageView.sd_setImage(with: URL(string: ImageSrc), completed: nil)
        image.imageHeight.constant = collectionView.frame.height
        image.imageWidth.constant = collectionView.frame.width
        
        image.imageCounterLabel.text = "\(indexPath.row + 1)/\(product.images.count)"
        image.imageCounterLabel.layer.masksToBounds = true
        image.imageCounterLabel.layer.cornerRadius = image.imageCounterLabel.frame.height / 2
        
        return image
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        imageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
    }
}
