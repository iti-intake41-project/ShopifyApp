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
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var totalPriceView: UIView!
    @IBOutlet weak var checkoutBtn: UIButton!
    var totalPrice: Float = 0
    var list:[Product] = []
    var viewModel:ShoppingBagViewModelTemp!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var productDetail: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        bindToViewModel()
        shoppingTable.delegate = self
        shoppingTable.dataSource = self
        
        updateTableView()
        

    }
    
    override func viewWillLayoutSubviews() {
        checkoutView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        totalPriceView.layer.cornerRadius = totalPriceView.layer.frame.height / 4
        checkoutBtn.layer.cornerRadius = checkoutBtn.layer.frame.height / 2
//        shoppingTable.backgroundView = UIImageView(image: UIImage(named: "cart background.jpg"))
    }
    
    func bindToViewModel(){
        viewModel.navigateToAddress = { [weak self] in
            self?.performSegue(withIdentifier: "navigateToAddress", sender: self!)
        }
        
        viewModel.navigateToPayment = { [weak self] in
            print("navigate to payment")
//            self?.showPayment()
            self?.performSegue(withIdentifier: "chooseAddressNavigation", sender: self!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseAddressNavigation" {
            if let nextViewController = segue.destination as? ChooseAddressViewController {
                    nextViewController.orders = list
            }
            //move
        }else if segue.identifier == "navToDetails" {
            if let nextViewController = segue.destination as? ProductDetailsViewController {
                    nextViewController.product = productDetail
            }

        }
    }
    
    @IBAction func navigateToCheckOut(_ sender: UIButton) {
        if !ConnectionViewModel.isConnected(){
                   showAlert(view: self)
        }
        else {
        if list.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Your cart is empty", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            viewModel.navigateToCheckOut()
        
        }
        }
    }
    
    
    func updateTableView(){
        totalPrice = 0
        list = []
        list = viewModel.getShoppingCartProductList()
        shoppingTable.reloadData()
        for product in list{
            totalPrice += (Float(product.varients?[0].price ?? "0.0") ?? 0.0) * Float(product.count)
        }
//        if viewModel.getCurrency() == "EGP"{
//            totalPriceText.text = String(format: "EGP %.2f", totalPrice)
//        }else{
//            totalPriceText.text = FormatePrice.formatePrice(priceStr: "\(totalPrice)")
//        }
        totalPriceText.text = FormatePrice.formatePrice(priceStr: "\(totalPrice)")
        
        if list.count == 0 {
            let imageView = UIImageView(image: UIImage(named: "emptyBag"))
            imageView.contentMode = .scaleAspectFill
            shoppingTable.backgroundView = imageView
        }else{
            shoppingTable.backgroundView = nil
        }
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
        cell.isFavourite = viewModel.isFavourite(id: list[indexPath.row].varients?[0].id ?? 0)
        cell.product = list[indexPath.row]
//        if viewModel.getCurrency() == "EGP"{
//            let cost = Float(list[indexPath.row].varients?[0].price ?? "0.0") ?? 0.0
//
//            cell.productPrice.text = "\((FormatePrice.formatePrice(priceStr: "\(cost)")))"
//        }else{
//            cell.productPrice.text = "US$\(FormatePrice.toEGP(amount: Double(list[indexPath.row].varients?[0].price ?? "0.0") ?? 0.0))"
//        }
        cell.productPrice.text = FormatePrice.formatePrice(priceStr: "\(list[indexPath.row].varients?[0].price ?? "0.0")")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = list[indexPath.row].varients?[0].id ?? 0
            viewModel.deleteProduct(id: id)
            updateTableView()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            increaseCount(id: list[indexPath.row].varients?[0].id ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productDetail = list[indexPath.row]
        print("select")
        performSegue(withIdentifier: "navToDetails", sender: self)
    }

}

// MARK: - ProductListDelegate

protocol productListDelegate {
    func deleteProduct(id: Int)
    func increaseCount(id: Int)
    func decreaseCount(id: Int)
    func isFavourite(id: Int)->Bool
    func addFavourite(product: Product)
    func deleteFavourite(id: Int)
}

extension ShoppingBagViewController : productListDelegate {
    func isFavourite(id: Int)->Bool {
        print("is favourite: \(viewModel.isFavourite(id: id))")
        return viewModel.isFavourite(id: id)
    }
    
    func addFavourite(product: Product) {
        viewModel.addFavourite(product: product)
    }
    
    func deleteFavourite(id: Int) {
        viewModel.deleteFavourite(id: id)
    }

    
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
                }else{
                    deleteProduct(id: id)
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
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}


// MARK: - View Radius

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

