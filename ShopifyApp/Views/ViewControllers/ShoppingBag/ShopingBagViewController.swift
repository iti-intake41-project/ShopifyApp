//
//  SHoppingBagViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 05/06/2021.
//

import UIKit

class ShoppingBagViewController: UIViewController {
    @IBOutlet weak var shoppingTable: UITableView!
    @IBOutlet weak var totalPriceText: UILabel!
    var totalPrice: Float = 0
    var list:[Product] = []
    var viewModel:ShoppingBagViewModelTemp!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        bindToViewModel()
        shoppingTable.delegate = self
        shoppingTable.dataSource = self
        
        updateTableView()
    }
    
    func bindToViewModel(){
        viewModel.navigateToAddress = { [weak self] in
            self?.performSegue(withIdentifier: "navigateToAddress", sender: self!)
        }
        
        viewModel.navigateToPayment = {
            print("navigate to payment")
        }
    }
    
    @IBAction func navigateToCheckOut(_ sender: UIButton) {
        viewModel.navigateToCheckOut()
    }
    
    func updateTableView(){
        totalPrice = 0
        list = []
        list = viewModel.getShoppingCartProductList()
        shoppingTable.reloadData()
        for product in list{
            totalPrice += (Float(product.varients?[0].price ?? "0.0") ?? 0.0) * Float(product.count)
        }
        totalPriceText.text = String(format: "US$%.2f", totalPrice)
    }
    
    func updateCD(id: Int){
        for product in list{
            if product.id == id {
                viewModel.updateProductList(id: id, product: product)
            }
        }
        updateTableView()
    }
    
    
}

// MARK: - Table View

extension ShoppingBagViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = shoppingTable.dequeueReusableCell(withIdentifier: "shoppingBagCell", for: indexPath) as! ShoppingBagTableViewCell
        cell.imgUrl = list[indexPath.row].images[0].src
        cell.delegate = self
        cell.product = list[indexPath.row]
        cell.productPrice.text = "US$\((Float(list[indexPath.row].varients?[0].price ?? "0.0") ?? 0.0))"
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
                print("i: \(i) id:\(self.list[i].id)")
                self.list[i].count += 1
                self.updateCD(id: id)
                //                self.updateTableView()
                break
            }
        }
        
    }
    
    func decreaseCount(id: Int) {
        for i in 0...self.list.count - 1{
            if id == self.list[i].id{
                print("i: \(i) id:\(self.list[i].id)")
                if self.list[i].count > 1 {
                    self.list[i].count -= 1
                    self.updateCD(id: id)
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
                    self.viewModel.deleteProduct(id: id)
                    self.updateTableView()
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
