//
//  ProductDetailsViewController.swift
//  ShopifyApp
//
//  Created by Abanob Wadie on 05/06/2021.
//

import UIKit
import SDWebImage

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productImagesCollectionView: UICollectionView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    
    var product: Product!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        setProductDetails()
    }
    @IBAction func favoriteAction(_ sender: Any) {
    }
    
    @IBAction func cartAction(_ sender: Any) {
        let shoppingViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        shoppingViewModel.addProduct(product: product)
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension ProductDetailsViewController {
    
    func style() {
        cartButton.layer.cornerRadius = cartButton.frame.height / 2
    }
    
    func setProductDetails() {
        productNameLabel.text = product.title
        
        if let varients = product.varients {
            productPriceLabel.text = varients[0].price
        }
        
        productDescriptionTextView.text = product.description
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! ProductDetailsCollectionViewCell
        
        let ImageSrc = product.images[indexPath.row].src
        image.productImageView.sd_setImage(with: URL(string: ImageSrc), completed: nil)
        
        image.imageCounterLabel.text = "\(indexPath.row + 1)/\(product.images.count)"
        
        return image
    }
    
    
}

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
    }
}
