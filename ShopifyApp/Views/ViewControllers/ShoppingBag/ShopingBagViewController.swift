//
//  SHoppingBagViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 05/06/2021.
//

import UIKit
import Stripe
import Alamofire

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
    var paymentSheet: PaymentSheet?
    var backendCheckoutUrl = URL(string: "https://shopify-app-iti.herokuapp.com/")!  // An example backend endpoint
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        bindToViewModel()
        shoppingTable.delegate = self
        shoppingTable.dataSource = self
        
        updateTableView()
        setupStripe()
    }
    
    override func viewWillLayoutSubviews() {
        checkoutView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        totalPriceView.layer.cornerRadius = totalPriceView.layer.frame.height / 4
        checkoutBtn.layer.cornerRadius = checkoutBtn.layer.frame.height / 2
//        shoppingTable.backgroundView = UIImageView(image: UIImage(named: "cart background.jpg"))
        if list.count == 0 {
            shoppingTable.backgroundView = UIImageView(image: UIImage(named: "empty cart.jpeg"))

            
        }
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
    
    @IBAction func navigateToCheckOut(_ sender: UIButton) {
        if list.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Your cart is empty", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            viewModel.navigateToCheckOut()
        
        }
    }
    
    func showPayment(){
        // MARK: Start the checkout process
        paymentSheet?.present(from: self) { paymentResult in
            // MARK: Handle the payment result
            switch paymentResult {
            case .completed:
                //self.displayAlert("Your order is confirmed!")
                print("completed")
            case .canceled:
                print("Canceled!")
            case .failed(let error):
                print(error)
                //self.displayAlert("Payment failed: \n\(error.localizedDescription)")
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
        if viewModel.getCurrency() == "EGP"{
            totalPriceText.text = FormatePrice.formatePrice(priceStr: "\(totalPrice)")
        }else{
            totalPriceText.text = String(format: "US$%.2f", totalPrice)
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
        if viewModel.getCurrency() == "EGP"{
            let cost = Float(list[indexPath.row].varients?[0].price ?? "0.0") ?? 0.0
            
            cell.productPrice.text = "\((FormatePrice.formatePrice(priceStr: "\(cost)")))"
        }else{
            cell.productPrice.text = "US$\((Float(list[indexPath.row].varients?[0].price ?? "0.0") ?? 0.0))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

//    private func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        // handle delete (by removing the data from your array and updating the tableview)
//        let id = list[indexPath.row].varients?[0].id ?? 0
//        viewModel.deleteProduct(id: id)
//        updateTableView()
//
//    }
    
//    private func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
//
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (action,arg) in
//            let id = self?.list[indexPath.row].varients?[0].id ?? 0
//            self?.viewModel.deleteProduct(id: id)
//            self?.updateTableView()
//        }
//
//        let editAction = UITableViewRowAction(style: .normal, title: "Edit") {(action,arg) in
//            //handle edit
//        }
//
//        return [deleteAction, editAction]
//    }

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

extension ShoppingBagViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    func createPaymentIntent(completion: @escaping STPJSONResponseCompletionBlock) {
        backendCheckoutUrl.appendPathComponent("create_payment_intent")
        
        AF.request(backendCheckoutUrl, method: .post, parameters: [:], encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
                        
            switch (response.result) {
            case .failure(let error):
                completion(nil, error)
            case .success(let json):
                completion(json as! [String:Any], nil)
            }
        }
    }
    
    func setupStripe() {
        createPaymentIntent { (paymentIntent, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else {
                guard let paymentIntent = paymentIntent as? [String:AnyObject] else{
                    print("incorrect")
                    return
                }
                
                let clientSecret = paymentIntent["secret"] as! String
                
                
                STPAPIClient.shared.publishableKey = "pk_test_51J19gZAzeb3g68XKkIDsHNLM8Fl0e6ncassqNHNaQfpuiktP41zn8cuxkANqftLC3SJnokBpwMt3292uHcNmsvnJ007BVuBDay"

                // MARK: Create a PaymentSheet instance
                var configuration = PaymentSheet.Configuration()
                configuration.merchantDisplayName = "Example, Inc."
//                configuration.applePay = .init(
//                    merchantId: "com.foo.example", merchantCountryCode: "US")
//                configuration.customer = .init(
//                    id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
                //configuration.returnURL = "payments-example://stripe-redirect"
                self.paymentSheet = PaymentSheet(
                    paymentIntentClientSecret: clientSecret,
                    configuration: configuration)
                
            }
        }
    }
}
