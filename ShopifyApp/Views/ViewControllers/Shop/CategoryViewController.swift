//
//  CategoryViewController.swift
//  ShopifyApp
//
//  Created by Asmaa Mohamed on 04/06/2021.
//

import UIKit
import SDWebImage

class CategoryViewController: UIViewController {

    @IBOutlet weak var productSearchBar: UISearchBar!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var subCategoriesTable: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var products: [Product]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toolBar.items![0].action = #selector(homeTabAction)
        toolBar.items![1].action = #selector(womenTabAction)
        toolBar.items![2].action = #selector(menTabAction)
        toolBar.items![3].action = #selector(kidsTabAction)
    }

    @objc func homeTabAction() {

    }

    @objc func womenTabAction() {

    }

    @objc func menTabAction() {

    }

    @objc func kidsTabAction() {

    }
    
    @IBAction func shoppingBagAction(_ sender: Any) {
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
    }
}



extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCategoryCell", for: indexPath) as! SubCategoriesCell
        
        switch indexPath.section {
        case 0:
            cell.title.text = "Shoes"
            break
        case 1:
            cell.title.text = "T-shirt"
            break
        case 2:
            cell.title.text = "3"
            break
        case 3:
            cell.title.text = "4"
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            
            break
        case 1:
            
            break
        case 2:
            
            break
        case 3:
            
            break
        default:
            break
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! CategoryProductsCollectionView
        
//        let images = products[indexPath.row].images
//        item.image.sd_setImage(with: URL(string: images[0].src), completed: nil)
        item.image.image = UIImage(named: "pic1")
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
