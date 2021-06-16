//
//  ShoppingBagTableViewCell.swift
//  ShopifyApp
//
//  Created by Moataz on 05/06/2021.
//

import UIKit
import SDWebImage

class ShoppingBagTableViewCell: UITableViewCell {
    @IBOutlet private weak var countStack: UIStackView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var itemCountText: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    
    var product: Product!{
        didSet{
            productName.text = product.title
            itemCountText.text = "\(product.count)"
        }
    }
    
    var isFavourite: Bool!{
        didSet{
            if isFavourite{
                likeBtn.tintColor = UIColor.red
            }
        }
    }
    
    var delegate: productListDelegate!
    
    var imgUrl:String!{
        didSet{
            loadImg()
        }
    }
    
    func loadImg(){
        productImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        productImage.sd_setImage(with: URL(string: imgUrl!), placeholderImage: UIImage(named: "placeholder"))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        countStack.layer.cornerRadius = 15
//        countStack.layer.borderWidth = 1
        minusBtn.layer.cornerRadius = 15
        minusBtn.layer.borderWidth = 2
        plusBtn.layer.cornerRadius = 15
        plusBtn.layer.borderWidth = 2
        priceView.layer.cornerRadius = 15
        priceView.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
      //      priceView.layer.borderColor = CGColor(red: 230, green: 0, blue: 0, alpha: 1)
        } else {
            // Fallback on earlier versions
        }
        productImage.roundCorners(corners: .allCorners, radius: 30)
    }
    
    @IBAction func toggleFav(_ sender: Any) {
        if delegate.isFavourite(id: product.varients?[0].id ?? 0){
            delegate.deleteFavourite(id: product.varients?[0].id ?? 0)
            likeBtn.tintColor = UIColor.white
        }else{
            delegate.addFavourite(product: product)
            likeBtn.tintColor = UIColor.red
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func decreaseCount(_ sender: Any) {
        print("decreaseCount")
        delegate.decreaseCount(id: product.id)
        self.awakeFromNib()
   }
    
    @IBAction func increaseCount(_ sender: Any) {
        print("increaseCount")
        delegate.increaseCount(id: product.id)
        self.awakeFromNib()
    }
}
