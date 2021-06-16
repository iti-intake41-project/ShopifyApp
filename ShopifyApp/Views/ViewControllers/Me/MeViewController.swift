//
//  MeViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/7/21.
//

import UIKit

class MeViewController: UIViewController {
    
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var imgOrder1: UIImageView!
    @IBOutlet weak var lblOrder1: UILabel!
    @IBOutlet weak var imgOrder2: UIImageView!
    @IBOutlet weak var imgOrder3: UIImageView!
    @IBOutlet weak var lblOrder2: UILabel!
    @IBOutlet weak var lblOrder3: UILabel!
    @IBOutlet weak var imgFav1: UIImageView!
    @IBOutlet weak var imgFav3: UIImageView!
    @IBOutlet weak var lblFav1: UILabel!
    @IBOutlet weak var lblFav2: UILabel!
    @IBOutlet weak var lblFav3: UILabel!
    @IBOutlet weak var imgFav2: UIImageView!
    @IBOutlet weak var order3StackView: UIStackView!
    @IBOutlet weak var order1StackVIew: UIStackView!
    @IBOutlet weak var fav1StackView: UIStackView!
    @IBOutlet weak var order2StackView: UIStackView!
    @IBOutlet weak var fav2StackView: UIStackView!
    @IBOutlet weak var fav3StackView: UIStackView!
    @IBOutlet weak var orderStackView: UIStackView!
    @IBOutlet weak var FavouriteStackVIew: UIStackView!
    @IBOutlet weak var loginOrRegisterStackView: UIStackView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var favCollectionView: UICollectionView!

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var meViewModel = MeViewModel()
    var isLoggedIn = false
    var favViewModel:FavouriteViewModelTemp!
    var favourites = [Product]()
    var orders = [Order]()
    var orderItems = [OrderItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        orderTableView.delegate = self
        orderTableView.dataSource = self
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        favViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        favViewModel.bindFavouritesList = onSuccess
         favourites = getfavourites()
        
        //
        // Do any additional setup after loading the view.
//        loginBtn.layer.cornerRadius = loginBtn.layer.frame.height  / 2
//        registerBtn.layer.cornerRadius = registerBtn.layer.frame.height / 2
    }
    override func viewWillAppear(_ animated: Bool) {
       orders =  meViewModel.getOrders()
        for order in orders {
            for orderItem in order.line_items {
                orderItems.append(orderItem)
                print("in for \(orderItem.price)")
            }
            
        }
        orderTableView.reloadData()
//        setOrderesUI(products: getOrders())
//        setWishListToUI(favourites: getfavourites())
//        
//       isLoggedIn = meViewModel.isLoggedIn()
//        
//        if isLoggedIn {
//            loginOrRegisterStackView.isHidden = true
//            orderStackView.isHidden = false
//            FavouriteStackVIew.isHidden = false
//            userLbl.text = "Welcome \(meViewModel.getUserName())"
//        }else{
//            loginOrRegisterStackView.isHidden = false
//            userLbl.isHidden = true
//            orderStackView.isHidden = true
//            FavouriteStackVIew.isHidden = true
//        }
        
    }
    
    func onSuccess(){
        print("dcjnjnc;")
       let  favouriteslist = favViewModel.favourites

        self.favourites = favouriteslist
        print(favourites.count)
        
        
    }
    @IBAction func login(_ sender: UIButton) {
        
        performSegue(withIdentifier:"login",sender:self)
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        performSegue(withIdentifier:"register",sender:self)
        
    }
    
    @IBAction func gotTOOrders(_ sender: UIButton) {
        if isLoggedIn {
            performSegue(withIdentifier: "gotToOrders", sender: self)
            
        }else {
            performSegue(withIdentifier: "login", sender: self)
        }
    }
    
    @IBAction func goToShoppingBag(_ sender: UIButton) {
        
        if isLoggedIn {
            performSegue(withIdentifier: "gotToShoppingBag", sender: self)
        }else {
            performSegue(withIdentifier: "login", sender: self)
        }
        
    }
    
    @IBAction func goTOWishList(_ sender: UIButton) {
        if isLoggedIn {
            performSegue(withIdentifier: "goToFav", sender: self)
        }else {
            performSegue(withIdentifier: "login", sender: self)
        }
    }
    @IBAction func gotoSetting(_ sender: Any) {
    }
    func getOrders() ->[Product]{
        let shoppingBagViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        return shoppingBagViewModel.getShoppingCartProductList()
        
    }
    func setOrderesUI(products:[Product]) {
        if products.count == 1 {
            imgOrder1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
            lblOrder1.text = products[0].title
            order2StackView.isHidden = true
            order3StackView.isHidden = true
            
        }
            
        else if products.count >= 3 {
            imgOrder1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
            imgOrder2.sd_setImage(with:URL(string:products[1].images[0].src), placeholderImage: UIImage(named: "noImage"))
            imgOrder3.sd_setImage(with:URL(string:products[2].images[0].src), placeholderImage: UIImage(named: "noImage"))
            
            lblOrder1.text = FormatePrice.formatePrice(priceStr: products[1].varients?[0].price)
            lblOrder2.text = FormatePrice.formatePrice(priceStr: products[2].varients?[0].price)
            lblOrder3.text = FormatePrice.formatePrice(priceStr: products[3].varients?[0].price)
            
            print(products[2].title)
            
            
        }
        else if products.count == 2 {
            imgOrder1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
            imgOrder2.sd_setImage(with:URL(string:products[1].images[0].src), placeholderImage: UIImage(named: "noImage"))
            
            lblOrder1.text = products[0].title
            lblOrder2.text = products[1].title
            order3StackView.isHidden = true
            
            
        }
        else{
            lblOrder1.text = "Not found orders"
            order2StackView.isHidden = true
            order3StackView.isHidden = true
        }
    }
    func getfavourites() ->[Product]{
        
        return meViewModel.getfavourites(appDelegate: &appDelegate)
        
    }
    
    func setWishListToUI(favourites products:[Product]) {
        if products.count == 1 {
            imgFav1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
            lblFav1.text = products[0].title
            fav2StackView.isHidden = true
            fav3StackView.isHidden = true
            
        }
            
        else if products.count >= 3 {
            imgFav1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
            imgFav2.sd_setImage(with:URL(string:products[1].images[0].src), placeholderImage: UIImage(named: "noImage"))
            imgFav3.sd_setImage(with:URL(string:products[2].images[0].src), placeholderImage: UIImage(named: "noImage"))
            
            lblFav1.text = FormatePrice.formatePrice(priceStr: products[1].varients?[0].price)
            lblFav2.text = FormatePrice.formatePrice(priceStr: products[2].varients?[0].price)
            lblFav3.text = FormatePrice.formatePrice(priceStr: products[3].varients?[0].price)
            
            print(products[2].title)
            
            
        }
        else if products.count == 2 {
            imgFav1.sd_setImage(with:URL(string:products[0].images[0].src), placeholderImage: UIImage(named: "noImage"))
            imgFav2.sd_setImage(with:URL(string:products[1].images[0].src), placeholderImage: UIImage(named: "noImage"))
            
            lblFav1.text = products[0].title
            lblFav2.text = products[1].title
            fav3StackView.isHidden = true
            
            
        }else{
            fav1StackView.isHidden = true
            fav2StackView.isHidden = true
            fav3StackView.isHidden = true
            
        }
    }
    
}

extension MeViewController :UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: "MeOrderTableViewCell") as! MeOrderTableViewCell
        cell.priceLbl.text = orderItems[indexPath.row].price
        print("cell\(cell.priceLbl.text)")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 150
    }
    
    
}
extension MeViewController : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 //favourites.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  favCollectionView.dequeueReusableCell(withReuseIdentifier: "WishListCollectionViewCell", for: indexPath) as! WishListCollectionViewCell
//        cell.imageWidth.constant = (favCollectionView.frame.width / 2) - 10
//        cell.imageHeight.constant = (favCollectionView.frame.height / 2) - 40
//        cell.productImg.sd_setImage(with: URL(string:favourites[indexPath.row].images[0].src), placeholderImage: UIImage(named: "noImage"))
//        cell.productLbl.text = favourites[indexPath.row].varients?[0].price
        cell.productLbl.text = "dckvmw"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: (collectionView.frame.width / 2), height: (collectionView.frame.height / 2) - 35)
     }
    
}
