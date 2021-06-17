//
//  Reachability.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/17/21.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
