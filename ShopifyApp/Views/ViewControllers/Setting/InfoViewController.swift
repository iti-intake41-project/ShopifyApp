//
//  InfoViewController.swift
//  ShopifyApp
//
//  Created by Abanob Wadie on 21/06/2021.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var info = String()
    var titleText = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = info
        // Do any additional setup after loading the view.
    }
    

}
