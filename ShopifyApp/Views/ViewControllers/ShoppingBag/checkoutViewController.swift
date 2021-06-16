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
    var deliveryFee: Float = 0.0
    var subTotalPrice: Float = 0.0
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var viewModel : CheckoutViewModel!
    var paymentCompleted = false
    private var request: PKPaymentRequest!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        couponText.label.text = "Coupon"
        viewModel = CheckoutViewModel(appDelegate: &delegate)
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        placeOrderBtn.layer.cornerRadius = placeOrderBtn.layer.frame.height / 2

        for order in orders{
            subTotalPrice += (Float(order.varients?[0].price ?? "0.0") ?? 0.0) * Float(order.count)
        }
        if viewModel.getCurrency() == "EGP"{
            subtotalText.text = FormatePrice.formatePrice(priceStr: "\(subTotalPrice)")
            if paymentType == "POD"{
                deliveryFee = 1.8
                shippingFeesText.text = FormatePrice.formatePrice(priceStr: "\(deliveryFee)")
            }else{
                shippingFeesText.text = "EGP 0.0"
            }
            totalText.text = FormatePrice.formatePrice(priceStr: "\(subTotalPrice+deliveryFee)")
            discountText.text = "EGP 0.0"
        }else{
            subtotalText.text = String(format: "US$ %.2f", subTotalPrice)
            if paymentType == "POD"{
                deliveryFee = 10.0
              shippingFeesText.text = "US$ 10.0"
            }else{
                shippingFeesText.text = "US$ 0.0"
            }
            totalText.text = String(format: "US$ %.2f", (subTotalPrice+deliveryFee))
            discountText.text = "US$ 0.0"
        }

    }
        
    @IBAction func validateCopoun(_ sender: Any) {
        if viewModel.checkCoupon(coupon: couponText.text ?? ""){
            if viewModel.getCurrency() == "EGP"{
                totalText.text = FormatePrice.formatePrice(priceStr: "\((subTotalPrice+deliveryFee) * 0.8)")
                
                discountText.text = FormatePrice.formatePrice(priceStr: "\((subTotalPrice+deliveryFee) * 0.2)")
                
            }else{
                totalText.text = String(format: "US$ %.2f", (subTotalPrice+deliveryFee)*0.8)
                discountText.text = String(format: "US$ %.2f", (subTotalPrice+deliveryFee)*0.2)
            }
        }else{
            if viewModel.getCurrency() == "EGP"{
                totalText.text = FormatePrice.formatePrice(priceStr: "\(subTotalPrice+deliveryFee)")
                discountText.text = "EGP 0.0"
            }else{
                totalText.text = String(format: "US$ %.2f", (subTotalPrice+deliveryFee))
                discountText.text = "US$ 0.0"
            }
            couponText.text = ""
            func showAlret(){
                let alert = UIAlertController(title: "Coupoon", message: "The coupon you entered is not valid", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }

        }
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        if paymentType == "POD" {
            viewModel.postOrder(products: &orders)
            showAlret()
        }else{
            //apple payment
            self.requestPayment(msg: "total", price: self.subTotalPrice)
        }
    }
    
    func showAlret(){
        let alert = UIAlertController(title: "Order", message: "Congratulations, your order has been placed successfully", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {[weak self] (action) in
            print("alert working")
            self?.performSegue(withIdentifier: "mainAfterPayment", sender: self!)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

