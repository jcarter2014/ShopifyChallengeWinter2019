//
//  ViewController.swift
//  ShopifyChallengeWinter2019
//
//  Created by John Carter on 9/11/18.
//  Copyright © 2018 Jack Carter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taggedProducts = [Product]()
    var filteredProducts = [Product]()
    var productInventory = 0
    var titlesAndInventories = [String: Int]()
    var titlesAndImages = [String: String]()
    var tags = [String]()
    
    struct Products: Decodable {
        let products: [Product]
    }
    
    struct Product: Decodable {
        let title: String
        let tags: String
        let images: [Image]
        let variants: [Variant]
    }
    
    struct Variant: Decodable {
        let inventory_quantity: Int
    }
    
    struct Image: Decodable {
        let src: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let jsonUrlString = "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let productList = try
                    JSONDecoder().decode(Products.self, from: data)
                    
                for thisProduct in productList.products {
                    
                    self.taggedProducts.append(thisProduct)
                    let allTags = thisProduct.tags.replacingOccurrences(of: ",", with: "")
                    let separatedTags = allTags.split(separator: " ")
                    
                    for tag in separatedTags {
                        if !self.tags.contains(String(tag)) {
                            self.tags.append(String(tag))
                        }
                    }
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = tags[indexPath.row]
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as? DetailViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let tag = tags[indexPath.row]
            filteredProducts = taggedProducts.filter { (product) -> Bool in
                product.tags.contains(tag)
            }
            for eachProduct in filteredProducts {
                
                let variants = eachProduct.variants
                for eachVariant in variants {
                    productInventory += eachVariant.inventory_quantity
                }
                titlesAndInventories[eachProduct.title] = productInventory
                detailVC?.detailVCtitlesAndInventories = titlesAndInventories

                productInventory = 0
                
                for eachImage in eachProduct.images {
                    titlesAndImages[eachProduct.title] = eachImage.src
                }
                detailVC?.detailVCtitlesAndImages = titlesAndImages
            }
        }
        detailVC?.filteredProducts = self.filteredProducts
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        filteredProducts = taggedProducts
        productInventory = 0
    }
}

