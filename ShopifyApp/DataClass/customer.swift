//
//  customer.swift
//  ShopifyApp
//
//  Created by Moataz on 05/06/2021.
//

import Foundation

struct NewCustomer: Codable {
    let customer: Customer
}

struct Customer: Codable {
    let first_name, last_name, email, phone, tags: String?
    let id: Int?
    let verified_email: Bool?
    let addresses: [Address]?
}

struct Address: Codable {
    var address1, city, province, phone: String?
    var zip, last_name, first_name, country: String?
}
struct LoginResponse: Codable {
    let customers: [Customer]
}

struct CustomerAddress: Codable {
    var addresses: [Address]?
}

struct PutAddress: Codable {
    let customer: CustomerAddress?
}

struct OrderItem: Codable {
    var variant_id, quantity: Int?
    var name: String! = ""
    var price: String!
}

struct OrderCustomer: Codable {
    var id: Int
}

struct Order: Codable {
    var line_items: [OrderItem]
    let customer: OrderCustomer
    var financial_status: String = "paid"
}

struct APIOrder: Codable {
    var order: Order
}

struct APIOrders: Codable {
    var orders: [Order]
}


extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

