//
//  ProductsCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/2/21.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet   weak var productImage: UIImageView!
    @IBOutlet   weak var priceLbl: UILabel!
    @IBOutlet   weak var favouriteBtn: UIButton!
    
    //Moataz
    var product: Product!
    
    var delegate: FavouriteProductCellProtocol!
    
    var isFavourite:Bool!{
        didSet{
            if isFavourite{
                favouriteBtn.backgroundColor = UIColor.red
            }
        }
    }
        
    @IBAction func toggleFavourite(_ sender: UIButton) {
        if delegate.isFavourite(id: product.id){
            delegate.deleteFavourite(id: product.id)
            //change button icon to NOT favourite
            favouriteBtn.backgroundColor = UIColor.white

        }else{
            delegate.addFavourite(product: product)
            //change button icon to favourite
            favouriteBtn.backgroundColor = UIColor.red

        }
    }
    //Moataz
}
