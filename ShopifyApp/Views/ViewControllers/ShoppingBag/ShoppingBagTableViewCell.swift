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
    
    var product: Product!{
        didSet{
            productName.text = product.title
            itemCountText.text = "\(product.count)"

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
        countStack.layer.cornerRadius = 15
        countStack.layer.borderWidth = 1
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
        delegate.deleteProduct(id: product.id)
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
