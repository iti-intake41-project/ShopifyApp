//
//  SHoppingBagViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 05/06/2021.
//

import UIKit
import PassKit

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
    private var request: PKPaymentRequest!
    
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
            
            self!.requestPayment(msg: "total", price: self!.totalPrice)
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

extension ShoppingBagViewController: PKPaymentAuthorizationViewControllerDelegate {
    func requestPayment(msg: String, price: Float) {
        
        request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.abanob.app"
        request.supportedNetworks = [.quicPay, .masterCard, .visa, .mada, .vPay]
        request.supportedCountries = ["US", "EG"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EG"
        request.currencyCode = UserDefaultsLayer().getCurrency()
        
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: msg, amount: NSDecimalNumber(value: price))]
        
        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
                
        if controller != nil {
            controller!.delegate = self
            present(controller!, animated: true, completion: nil)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
        
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}
