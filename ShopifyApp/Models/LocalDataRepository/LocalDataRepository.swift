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
    func getShoppingCartProductList()->[Product]
    func emptyCart()
    func deleteProduct(id: Int)
    func addFavourite(product: Product)
    func deleteFavourite(id: Int)
    func getFavourites()->[Product]
    func addAddress(address: Address)
    func deleteAddress()
    func hasAddress()->Bool
    func getAddress()->Address
    func getAddresses()->[Address]
}

class CoreDataRepository: LocalDataRepository {
    
    var productList = [Product]()
    var favouriteList = [Product]()
    var delegate: AppDelegate
    
    init(appDelegate: inout AppDelegate) {
        delegate = appDelegate
    }
    
    // MARK: - Shopping Cart
    func getShoppingCartProductList()->[Product] {
        productList = []
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCoreData")
        do{
            let productCDArray = try managedContext.fetch(fetchRequest)
//            print("fetch product CD count \(productCDArray.count)")
            for product in productCDArray{
                let id = product.value(forKey: "id") as! Int
//                print("read id: \(id)")
                let count = product.value(forKey: "count") as! Int
                let price = product.value(forKey: "price") as! String
                let title = product.value(forKey: "title") as! String
                let imgUrl = product.value(forKey: "imgUrl") as! String
                var product = Product(id: id, title: title, description: "mens shoes", vendor: nil, productType: "Shoes", images: [ProductImage(id: id, productID: 1, position: 1, width: 1, height: 1, src: imgUrl, graphQlID: "")], options: nil, varients: [Varient(id: id, productID: 0, title: "", price: price)])
                product.count = count
//                print(price)
                productList.append(product)
            }
        }catch{
            print("failed to load products from core data \(error.localizedDescription)")
        }
        
        return productList
    }
    
    func addProduct(product: Product) {
//        print("add product in CD \(product)")
        let managedContext = delegate.persistentContainer.viewContext
        //3
        let entity = NSEntityDescription.entity(forEntityName: "ProductCoreData", in: managedContext)
        //4
        let productCD = NSManagedObject(entity: entity!, insertInto: managedContext)
        productCD.setValue(product.varients?[0].id ?? 0, forKey: "id")
        productCD.setValue(product.count + 1, forKey: "count")
        productCD.setValue(product.varients?[0].price ?? "0.0", forKey: "price")
        productCD.setValue(product.title, forKey: "title")
        productCD.setValue(product.images[0].src, forKey: "imgUrl")
        do{
            try managedContext.save()
            print("product saved successfully in cart")
        }catch let error as NSError{
            print("error occured while saving product in cart \(error.localizedDescription)")
        }
    }
    
    func updateProductList(id: Int, product: Product) {
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCoreData")
        fetchRequest.predicate = NSPredicate(format: "id = \(id)")
//        print("edit id \(id)")
        do{
            let productCDArray = try managedContext.fetch(fetchRequest)
//            print("update list count: \(productCDArray.count)")
            for productCD in productCDArray{
//                print("update list count: \(productCD)")
                
                productCD.setValue(product.varients?[0].id ?? 0, forKey: "id")
                productCD.setValue(product.count, forKey: "count")
                productCD.setValue(product.varients?[0].price ?? "0.0", forKey: "price")
                productCD.setValue(product.title, forKey: "title")
                productCD.setValue(product.images[0].src, forKey: "imgUrl")
                
            }
            try managedContext.save()
        }catch{
            print("failed to update product in core data \(error.localizedDescription)")
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
    
    func emptyCart(){
        print("empty cart function")
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCoreData")
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
    
    
    // MARK: - Favourites
    
    func deleteFavourite(id: Int) {
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCoreData")
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
    
    func addFavourite(product: Product) {
        print("add product in CD \(product)")
        let managedContext = delegate.persistentContainer.viewContext
        //3
        let entity = NSEntityDescription.entity(forEntityName: "FavouriteCoreData", in: managedContext)
        //4
        let productCD = NSManagedObject(entity: entity!, insertInto: managedContext)
        productCD.setValue(product.varients?[0].id ?? 0, forKey: "id")
        productCD.setValue(product.varients?[0].price ?? "0.0", forKey: "price")
        productCD.setValue(product.title, forKey: "title")
        productCD.setValue(product.images[0].src, forKey: "imgUrl")
        do{
            try managedContext.save()
            print("favourite saved successfully")
        }catch let error as NSError{
            print("failed to update favourite in core data \(error.localizedDescription)")
        }
    }
    
    func getFavourites() -> [Product] {
        favouriteList = []
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCoreData")
        do{
            let productCDArray = try managedContext.fetch(fetchRequest)
//            print("fetch product CD count \(productCDArray.count)")
            for product in productCDArray{
                let id = product.value(forKey: "id") as! Int
//                print("read id: \(id)")
                let price = product.value(forKey: "price") as! String
                let title = product.value(forKey: "title") as! String
                let imgUrl = product.value(forKey: "imgUrl") as! String
                let product = Product(id: id, title: title, description: "mens shoes", vendor: nil, productType: "Shoes", images: [ProductImage(id: id, productID: 1, position: 1, width: 1, height: 1, src: imgUrl, graphQlID: "")], options: nil, varients: [Varient(id: id, productID: 0, title: "", price: price)])
//                print(price)
                favouriteList.append(product)
            }
        }catch{
            print("failed to load favourites from core data \(error.localizedDescription)")
        }
        return favouriteList
    }
    
    // MARK: - Customer Address
    
    func addAddress(address: Address) {
        let managedContext = delegate.persistentContainer.viewContext
        //3
        let entity = NSEntityDescription.entity(forEntityName: "AddressCoreData", in: managedContext)
        //4
        let addressCD = NSManagedObject(entity: entity!, insertInto: managedContext)
        addressCD.setValue(address.country ?? "", forKey: "country")
        addressCD.setValue(address.city ?? "", forKey: "city")
        addressCD.setValue(address.address1 ?? "", forKey: "address1")
        addressCD.setValue(address.zip ?? "", forKey: "zip")
        do{
            try managedContext.save()
            print("address saved successfully")
        }catch let error as NSError{
            print("error occured while saving address \(error.localizedDescription)")
        }
        
    }
    
    func deleteAddress() {
        let context = delegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
            try context.execute(deleteRequest)
            try context.save()
        }catch{
            print ("error happened while deleting addresses \(error.localizedDescription)")
        }
        
    }
    
    func hasAddress()->Bool {
        if getAddress().address1 != ""{
            return true
        }
        return false
    }
    
    func getAddress()->Address {
        var address = Address(address1: "", city: "", province: "", phone: "", zip: "", last_name: "", first_name: "", country: "")
        
        
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AddressCoreData")
        do{
            let addressCDArray = try managedContext.fetch(fetchRequest)
            print("fetch address CD count \(addressCDArray.count)")
            for addressCD in addressCDArray{
                address.country = addressCD.value(forKey: "country") as? String
                address.city = addressCD.value(forKey: "city") as? String
                address.address1 = addressCD.value(forKey: "address1") as? String
                address.zip = addressCD.value(forKey: "zip") as? String
            }
        }catch{
            print("failed to load address from core data \(error.localizedDescription)")
        }
        
        return address
    }
    
    func getAddresses()->[Address] {
        var addresses: [Address] = []
        
        
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AddressCoreData")
        do{
            let addressCDArray = try managedContext.fetch(fetchRequest)
            print("fetch address CD count \(addressCDArray.count)")
            for addressCD in addressCDArray{
                var address = Address(address1: "", city: "", province: "", phone: "", zip: "", last_name: "", first_name: "", country: "")

                address.country = addressCD.value(forKey: "country") as? String
                address.city = addressCD.value(forKey: "city") as? String
                address.address1 = addressCD.value(forKey: "address1") as? String
                address.zip = addressCD.value(forKey: "zip") as? String
                
                addresses.append(address)
            }
        }catch{
            print("failed to load address from core data \(error.localizedDescription)")
        }
        
        return addresses

    }
}
