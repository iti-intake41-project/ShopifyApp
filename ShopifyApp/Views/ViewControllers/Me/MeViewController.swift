//
//  MeViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/7/21.
//

import UIKit

class MeViewController: UIViewController {
    
    @IBOutlet weak var userLbl: UILabel!
    
    
    
    @IBOutlet weak var ordersHieght: NSLayoutConstraint!
    @IBOutlet weak var favHeight: NSLayoutConstraint!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var favCollectionView: UICollectionView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginOrRegisterStackView: UIStackView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var meViewModel = MeViewModel()
    var isLoggedIn = false
    var favViewModel:FavouriteViewModelTemp!
    var favourites = [Product]()
    var orders = [Order]()
    var orderItems = [OrderItem]()
    var productDetails: Product?
    var count :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        orderTableView.delegate = self
        orderTableView.dataSource = self
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        favViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
        
        
        
        //        meViewModel.updateOrders = {
        //            self.orderItems = self.meViewModel.orderItems
        //            self.ordersHieght.constant = CGFloat((self.orderItems.count / 2) * 120)
        //            self.orderTableView.reloadData()
        //        }
        
        meViewModel.bindOrders = {
            self.orders = self.meViewModel.orders
            //        self.ordersHieght.constant = CGFloat((self.orders.count / 2) * 120)
            if(self.orders.count >= 6){
                self.count = 6
            }else{
                self.count = self.orders.count
            }
            self.orderTableView.reloadData()
            
        }
        
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
        orders =  meViewModel.getOrders()
        favourites = favViewModel.getAllFaourites()
        //   favourites = favViewModel.favourites
        
        favViewModel.bindFavouritesList = { [weak self] in
            self?.favourites = self?.favViewModel.favourites ?? []
            self?.favHeight.constant = CGFloat((self?.favourites.count)! / 2 * 200)
            
            self?.favCollectionView.reloadData()
            print("bind fav")
        }
        print("willappear")
        
        isLoggedIn = meViewModel.isLoggedIn()
        
        tabBarController?.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(gotoSetting(_:))),  UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: self, action: #selector(goToShoppingBag(_:)))]
        tabBarController?.navigationItem.leftBarButtonItems =  []
        tabBarController?.navigationItem.title = "Me"
    }
    
    
    func onSuccess(){
        print("dcjnjnc;")
       let  favouriteslist = favViewModel.favourites

        self.favourites = favouriteslist
        print(favourites.count)
        
        if isLoggedIn {
            if !ConnectionViewModel.isConnected(){
                       showAlert(view: self)
                   }
            loginOrRegisterStackView.isHidden = true
            orderTableView.isHidden = false
            favCollectionView.isHidden = false
            userLbl.text = "Welcome \(meViewModel.getUserName())"
        }else{
            loginOrRegisterStackView.isHidden = false
            userLbl.isHidden = true
            orderTableView.isHidden = true
            favCollectionView.isHidden = true
        }
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
        performSegue(withIdentifier: "goToSettings", sender: self)
    }
    //    func getOrders() ->[Product]{
    //        let shoppingBagViewModel = ShoppingBagViewModel(appDelegate: &appDelegate)
    //        return shoppingBagViewModel.getShoppingCartProductList()
    //
    //    }
    
    
}

extension MeViewController :UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: "MeOrderTableViewCell") as! MeOrderTableViewCell
        cell.priceLbl.text = orders[indexPath.row].current_total_price
        cell.creationDateLbl.text = orders[indexPath.row].created_at
        
        return cell
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //       return 150
    //    }
    
    
}
extension MeViewController : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourites.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  favCollectionView.dequeueReusableCell(withReuseIdentifier: "wishlist", for: indexPath) as! WishListCollectionViewCell
        
        cell.imageWidth.constant = (collectionView.frame.width / 2) - 10
        cell.imageHeight.constant = 200
        
        cell.imageWidth.constant = (favCollectionView.frame.width / 2) - 10
        cell.imageHeight.constant = (favCollectionView.frame.height / 2) - 40
        cell.productImg.sd_setImage(with: URL(string:favourites[indexPath.row].images[0].src), placeholderImage: UIImage(named: "noImage"))
        cell.productLbl.text = favourites[indexPath.row].varients?[0].price
        //      cell.productLbl.text = "dckvmw"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        productDetails = favourites[indexPath.row]
        performSegue(withIdentifier: "ProductDetailsViewController", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetailsViewController" {
            let navController = segue.destination as! ProductDetailsViewController
            navController.product = productDetails
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 10, height: 200)
    }
    
}
