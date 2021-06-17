//
//  ShowAlerts.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/17/21.
//

import Foundation
import UIKit

    

    func showAlert(view :UIViewController) {
    
    let alert = UIAlertController(title: "No Internet Connection", message: "please Check your internet connection ", preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default)
    alert.addAction(action)
    view.present(alert, animated: true, completion: nil)


}


