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
                //donia
                //favouriteBtn.backgroundColor = UIColor.red
                favouriteBtn.setImage(UIImage(named: "redheart"), for: .normal)
                //donia
            }
        }
    }
    
    @IBAction func toggleFavourite(_ sender: UIButton) {

        if delegate.isFavourite(id: product.varients?[0].id ?? 0){
            print("is favourite cell: \(product.varients?[0].id ?? 0)")

            delegate.deleteFavourite(id: product.varients?[0].id ?? 0)
            //change button icon to NOT favourite
             //donia
             //favouriteBtn.backgroundColor = UIColor.white
             favouriteBtn.setImage(UIImage(named: "heart"), for: .normal)
            //donia
            
            print("not favourite")

        }else{
            delegate.addFavourite(product: product)
            //change button icon to favourite
            //donia
            //favouriteBtn.backgroundColor = UIColor.red
            favouriteBtn.setImage(UIImage(named: "redheart"), for: .normal)
            //donia
            print("is favourite")
        }
        print("prdouct id: \(product.varients?[0].id ?? 0)")

    }
    //Moataz
}
