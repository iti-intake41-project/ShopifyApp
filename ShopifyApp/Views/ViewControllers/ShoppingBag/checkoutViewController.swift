//
//  checkoutViewController.swift
//  ShopifyApp
//
//  Created by Moataz on 16/06/2021.
//

import UIKit
import PassKit
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class checkoutViewController: UIViewController {
    var orders: [Product]!
    var paymentType: String!
    var address: Address!
    @IBOutlet weak var subtotalText: UILabel!
    @IBOutlet weak var shippingFeesText: UILabel!
    @IBOutlet weak var couponText: MDCOutlinedTextField!
    @IBOutlet weak var discountText: UILabel!
    @IBOutlet weak var totalText: UILabel!
    @IBOutlet weak var placeOrderBtn: UIButton!
    var totalPrice: Float = 0.0
    var discountPrice: Float = 0.0
    var deliveryFee: Float = 0.0
    var subTotalPrice: Float = 0.0
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var viewModel : CheckoutViewModel!
    var paymentCompleted = false
    private var request: PKPaymentRequest!
    var applyDiscount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        couponText.label.text = "Coupon"
        viewModel = CheckoutViewModel(appDelegate: &delegate)
        
        setUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         if !ConnectionViewModel.isConnected(){
                   showAlert(view: self)
               }
    }
    
    func setUI(){
        navigationItem.title = "Check Out"
        placeOrderBtn.layer.cornerRadius = placeOrderBtn.layer.frame.height / 2
        for order in orders{
            subTotalPrice += (Float(order.varients?[0].price ?? "0.0") ?? 0.0) * Float(order.count)
        }
        updatePrices()
    }
    
    func updatePrices(){
        if paymentType == "POD"{
            deliveryFee = 30.0
        }
        if applyDiscount{
            totalPrice = (subTotalPrice + deliveryFee) * 0.8
            discountPrice = (subTotalPrice + deliveryFee) * 0.2
        }else{
            totalPrice = subTotalPrice + deliveryFee
            discountPrice = 0.0
        }

        subtotalText.text = FormatePrice.formatePrice(priceStr: "\(subTotalPrice)")
        shippingFeesText.text = FormatePrice.formatePrice(priceStr: "\(deliveryFee)")
        discountText.text = FormatePrice.formatePrice(priceStr: "\(discountPrice)")
        totalText.text = FormatePrice.formatePrice(priceStr: "\(totalPrice)")

        if viewModel.getCurrency() == "EGP"{
            totalPrice = Float("\(FormatePrice.toEGP(amount: Double("\(totalPrice)") ?? 0))") ?? 0.0
        }else{
//            subtotalText.text = FormatePrice.formatePrice(priceStr: "\(subTotalPrice)")
//            shippingFeesText.text = FormatePrice.formatePrice(priceStr: "\(deliveryFee)")
//            discountText.text = FormatePrice.formatePrice(priceStr: "\(discountPrice)")
//            totalText.text = FormatePrice.formatePrice(priceStr: "\(totalPrice)")
//            totalPrice = Float("\(FormatePrice.toEGP(amount: Double("\(totalPrice)") ?? 0.0))") ?? 0.0
        }
        
        

        
    }
        
    @IBAction func validateCopoun(_ sender: Any) {
        applyDiscount = viewModel.checkCoupon(coupon: couponText.text ?? "")
        updatePrices()
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        if paymentType == "POD" {
//            viewModel.postOrder(products: &orders)
            showAlret()
        }else{
            //apple payment
            self.requestPayment(msg: "total", price: totalPrice)
        }
    }
    
    func showAlret(){
        self.viewModel.postOrder(products: &self.orders)
        let alert = UIAlertController(title: "Order", message: "Congratulations, your order has been placed successfully", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {[weak self] (action) in
            print("alert working")
            if let self = self {
                self.performSegue(withIdentifier: "mainAfterPayment", sender: self)
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

}


// MARK: - Apple pay

extension checkoutViewController: PKPaymentAuthorizationViewControllerDelegate {
    func requestPayment(msg: String, price: Float) {
        
        request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.abanob.app"
        request.supportedNetworks = [.quicPay, .masterCard, .visa, .mada, .vPay]
        request.supportedCountries = ["US", "EG"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EG"
        request.currencyCode = UserDefaultsLayer().getCurrency()
        print("coming currency :\(UserDefaultsLayer().getCurrency())")
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: msg, amount: NSDecimalNumber(value: price))]
        
        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
                
        if controller != nil {
            controller!.delegate = self
            present(controller!, animated: true, completion: nil)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)

        if paymentCompleted {
            showAlret()
        }
        
    }
        
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        paymentCompleted = true
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))

    }
}

