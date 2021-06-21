//
//  OrderDetailsTableViewCell.swift
//  ShopifyApp
//
//  Created by Abanob Wadie on 19/06/2021.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
