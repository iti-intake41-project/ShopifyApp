//
//  SHoppingBagViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 05/06/2021.
//

import UIKit

class ShoppingBagViewController: UIViewController {
    @IBOutlet weak var shoppingTable: UITableView!
    var product = Product(id: 1, title: "Sketcher", description: "mens shoes", vendor: nil, productType: "Shoes", images: [ProductImage(id: 1, productID: 1, position: 1, width: 1, height: 1, src: "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/44694ee386818f3276566210464cf341.jpg?v=1621288163", graphQlID: "")], options: nil, varients: nil)
    var product2 = Product(id: 2, title: "Sketcher2", description: "mens shoes", vendor: nil, productType: "Shoes", images: [ProductImage(id: 2, productID: 1, position: 1, width: 1, height: 1, src: "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/44694ee386818f3276566210464cf341.jpg?v=1621288163", graphQlID: "")], options: nil, varients: nil)
    var product3 = Product(id: 3, title: "Sketcher3", description: "mens shoes", vendor: nil, productType: "Shoes", images: [ProductImage(id: 3, productID: 1, position: 1, width: 1, height: 1, src: "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/44694ee386818f3276566210464cf341.jpg?v=1621288163", graphQlID: "")], options: nil, varients: nil)
    var product4 = Product(id: 4, title: "Sketcher4", description: "mens shoes", vendor: nil, productType: "Shoes", images: [ProductImage(id: 3, productID: 1, position: 1, width: 1, height: 1, src: "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/44694ee386818f3276566210464cf341.jpg?v=1621288163", graphQlID: "")], options: nil, varients: nil)
    var list:[Product] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingTable.delegate = self
        shoppingTable.dataSource = self
        list.append(product)
        list.append(product2)
        list.append(product3)
        list.append(product4)
        // Do any additional setup after loading the view.
    }
}

// MARK: - Table View

extension ShoppingBagViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = shoppingTable.dequeueReusableCell(withIdentifier: "shoppingBagCell", for: indexPath) as! ShoppingBagTableViewCell
        cell.imgUrl = list[indexPath.row].images[0].src
        cell.delegate = self
        cell.product = list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - ProductListDelegate

protocol productListDelegate {
    func deleteProduct(id: Int)
    func increaseCount(id: Int)
    func decreaseCount(id: Int)
}

extension ShoppingBagViewController : productListDelegate {
    func increaseCount(id: Int) {
        for i in 0...self.list.count - 1{
            if id == self.list[i].id{
                print("i: \(i)")
                self.list[i].count += 1
                self.shoppingTable.reloadData()
                break
            }
        }

    }
    
    func decreaseCount(id: Int) {
        for i in 0...self.list.count - 1{
            if id == self.list[i].id{
                print("i: \(i)")
                if self.list[i].count > 1 {
                    self.list[i].count -= 1
                    self.shoppingTable.reloadData()
                    break
                }
            }
        }

    }
    
    func deleteProduct(id: Int) {
        print("id: \(id)")
        let alert = UIAlertController(title: "Remove Product", message: "Are you sure you want to remove this product from your cart?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { [weak self] (action) in
            guard let self = self else {return}
            for i in 0...self.list.count - 1{
                if id == self.list[i].id{
                    print("i: \(i)")
                    self.list.remove(at: i)
                    self.shoppingTable.reloadData()
                    break
                }
            }
        }
        let noAction = UIAlertAction(title: "NO", style: .default)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
