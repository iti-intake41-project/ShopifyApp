//
//  ShopViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 5/22/21.
//

import UIKit

class ShopViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    @IBOutlet weak var UIPageControl: UIPageControl!
    
    var adsArray = [UIImage(named: "pic")!,UIImage(named: "pic1")!,UIImage(named: "pic1")!]
    var timer :Timer?
    var currentCellIndex = 0
    
    
    var products: [Product] = [Product]()
    let shopViewModel: ShopViewModel = ShopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shopCollectionView.delegate=self
        shopCollectionView.dataSource=self
        startTimer()
        UIPageControl.numberOfPages = adsArray.count
        
        // Do any additional setup after loading the view.
        
        shopViewModel.bindShopViewModelToView  = onSuccessUpdateView
        shopViewModel.bindViewModelErrorToView = onFailUpdateView
        //call  products from viewController based on collectionID
        shopViewModel.fetchCustomCollection()
        shopViewModel.fetchAllProductsFromAPI()
    }
    
    func startTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextSlide), userInfo: nil, repeats: true)
    }
    
    @objc func moveToNextSlide()
    {
        if(currentCellIndex < adsArray.count-1)
        {
            currentCellIndex+=1
        }
        else{
            currentCellIndex = 0
        }
        
        shopCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        UIPageControl.currentPage = currentCellIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = shopCollectionView.dequeueReusableCell(withReuseIdentifier: "ShopCell", for: indexPath) as! ShopCollectionViewCell
        cell.shopAdsImages.image = adsArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        adsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func onSuccessUpdateView() {
      guard let products = shopViewModel.allProducts
       else {
        print("no products")
        return }
        self.products = products

        print(products.count)
        print(products[0].title)
//        print(products[0].productType!)
        print("-------------------------")
    }
    func onFailUpdateView() {
        let alert = UIAlertController(title: "Error", message: shopViewModel.showError, preferredStyle: .alert)
             
             let okAction  = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                 
                 
             }
             
             
             alert.addAction(okAction)
             self.present(alert, animated: true, completion: nil)
    }

}
