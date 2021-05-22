//
//  URLs.swift
//  ShopifyApp
//
//  Created by Abanob Wadie on 19/05/2021.
//

import Foundation

class URLs {
    private static var baseUrl = "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com/admin/api/2021-04/"
    
    static func categories() -> String {
        return baseUrl + "custom_collections.json"
    }
}
