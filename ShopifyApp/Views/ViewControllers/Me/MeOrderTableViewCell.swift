//
//  MeOrderTableViewCell.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/16/21.
//

import UIKit

class MeOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
     @IBOutlet weak var creationDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
