//
//  ViewController.swift
//  ImageTable
//
//  Created by Keishin CHOU on 2019/11/24.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var items = [String]()
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Image Table"
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        
        let fm = FileManager.default
        var imageRootName: String
        var imagePath: String
        var image: UIImage
        
        if let tempItems = try? fm.contentsOfDirectory(atPath: Bundle.main.resourcePath!) {
            for item in tempItems {
                if item.range(of: "Large") != nil {
                    items.append(item)
                    
                    imageRootName = item.replacingOccurrences(of: "Large", with: "Thumb")
                    imagePath = Bundle.main.path(forResource: imageRootName, ofType: nil)!
                    image = UIImage(contentsOfFile: imagePath)!
                    
                    images.append(image)
                    
                    print("imagePath is \(imagePath)")
                    print("documentDirectory is \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count * 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentImage = images[indexPath.row % images.count]
        
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)

        let rounded = renderer.image { (ctx) in
            ctx.cgContext.addEllipse(in: renderRect)
            ctx.cgContext.clip()

            currentImage.draw(in: renderRect)
        }
        
        cell.imageView?.image = rounded
        
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius = 10
        cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath
        
        return cell
    }


}

