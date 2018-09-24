//
//  DetailViewController.swift
//  ShopifyChallengeWinter2019
//
//  Created by John Carter on 9/23/18.
//  Copyright © 2018 Jack Carter. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var filteredProducts = [ViewController.Product]()
    var detailVCtitlesAndInventories = [String: Int]()
    var detailVCtitlesAndImages = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Products List Page"
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DetailTableViewCell
        
        let productName = filteredProducts[indexPath.row]
        cell?.productName.text = productName.title
        
        let productNumber = detailVCtitlesAndInventories[productName.title]
        cell?.productInventory.text = "\(productNumber ?? 0) in stock"
        
        let imageURLString = detailVCtitlesAndImages[productName.title]
        let url = URL(string: imageURLString!)
        let data = try? Data(contentsOf: url!)
        cell?.productImage.contentMode = .scaleAspectFill
        cell?.productImage.image = UIImage(data: data!)

        return cell!
    }
}
