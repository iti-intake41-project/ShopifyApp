//
//  FavouriteProductCellProtocol.swift
//  ShopifyApp
//
//  Created by Moataz on 08/06/2021.
//

import Foundation

protocol FavouriteProductCellProtocol {
    func isFavourite(id: Int)->Bool
    func deleteFavourite(id: Int)
    func addFavourite(product: Product)
    func isLogin()->Bool
    func navTologin()
}
