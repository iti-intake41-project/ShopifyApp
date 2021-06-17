//
//  ConnectionViewModel.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/17/21.
//

import Foundation
class ConnectionViewModel {
   static func isConnected() -> Bool {
        return Connectivity.isConnectedToInternet
        
    }
}
