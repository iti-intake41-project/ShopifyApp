//
//  LocalDataRepository.swift
//  ShopifyApp
//
//  Created by Moataz on 05/06/2021.
//

import Foundation
import CoreData

protocol LocalDataRepository{
    func addProduct(product: Product)
    func updateProductList(id: Int, product: Product)
    func getProductList()->[Product]
    func deleteProduct(id: Int)
}

class RealmDataRepository: LocalDataRepository {
    var productList = [Product]()
    var delegate: AppDelegate
    
    init(appDelegate: inout AppDelegate) {
        delegate = appDelegate
    }

    func getProductList()->[Product] {
        productList = []
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCoreData")
        do{
            let productCDArray = try managedContext.fetch(fetchRequest)
            print("fetch product CD count\(productCDArray.count)")
            for product in productCDArray{
                let id = product.value(forKey: "id") as! Int
                print("read id: \(id)")
                let count = product.value(forKey: "count") as! Int
                let price = product.value(forKey: "price") as! String
                let title = product.value(forKey: "title") as! String
                let imgUrl = product.value(forKey: "imgUrl") as! String
                var product = Product(id: id, title: title, description: "mens shoes", vendor: nil, productType: "Shoes", images: [ProductImage(id: id, productID: 1, position: 1, width: 1, height: 1, src: imgUrl, graphQlID: "")], options: nil, varients: [Varient(id: 0, productID: 0, title: "", price: price)])
                product.count = count
                print(price)
                productList.append(product)
            }
        }catch{
            print("failed to load products from core data")
        }

        return productList
    }
         
    func addProduct(product: Product) {
        print("add product in CD \(product)")
        let managedContext = delegate.persistentContainer.viewContext
        //3
        let entity = NSEntityDescription.entity(forEntityName: "ProductCoreData", in: managedContext)
        //4
        let productCD = NSManagedObject(entity: entity!, insertInto: managedContext)
        productCD.setValue(product.id, forKey: "id")
        productCD.setValue(product.count, forKey: "count")
        productCD.setValue(product.varients?[0].price ?? "0.0", forKey: "price")
        productCD.setValue(product.title, forKey: "title")
        productCD.setValue(product.images[0].src, forKey: "imgUrl")
        do{
            try managedContext.save()
            print("saved successfully")
        }catch let error as NSError{
            print(error)
        }

    }
    
    func updateProductList(id: Int, product: Product) {
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCoreData")
        fetchRequest.predicate = NSPredicate(format: "id = \(id)")
        print("edit id \(id)")
        do{
            let productCDArray = try managedContext.fetch(fetchRequest)
            print("update list count: \(productCDArray.count)")
            for productCD in productCDArray{
                print("update list count: \(productCD)")

                productCD.setValue(product.id, forKey: "id")
                productCD.setValue(product.count, forKey: "count")
                productCD.setValue(product.varients?[0].price ?? "0.0", forKey: "price")
                productCD.setValue(product.title, forKey: "title")
                productCD.setValue(product.images[0].src, forKey: "imgUrl")

            }
            try managedContext.save()
        }catch{
            print("failed to update product in core data")
        }
    }
    
    func deleteProduct(id: Int) {
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCoreData")
        fetchRequest.predicate = NSPredicate(format: "id = \(id)")
        do{
            let productCDArray = try managedContext.fetch(fetchRequest)
            for product in productCDArray {
                managedContext.delete(product)
            }
            try managedContext.save()

        }catch{
            print("failed to delete product from core data \(error)")
        }
    }
}
