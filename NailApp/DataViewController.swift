//
//  DataViewController.swift
//  pageBasedTest
//
//  Created by DaichiSaito on 2016/02/09.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//
import Foundation
import UIKit

class DataViewController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var detailImage2: UIImageView!
    var dataObject: String = ""
    var dataImage: UIImage?
//    var imageInfo: NSDictionary = [:]
    var imageInfo: NCMBObject?
//    var url: String = ""
    var url: NSURL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let url = NSURL(string: (self.imageInfo!.objectForKey("imagePath") as? String)!)
        let placeholder = UIImage(named: "transparent.png")
        self.detailImage2.setImageWithURL(url, placeholderImage: placeholder)
        self.detailImage2.frame = CGRectZero
        if (self.detailImage2.image != nil) {
            self.detailImage2.translatesAutoresizingMaskIntoConstraints = true
            let imageHeight = self.detailImage2.image!.size.height*screenWidth/self.detailImage2.image!.size.width
            self.detailImage2.frame = CGRectMake(0, 0, screenWidth, imageHeight)
        }
//        self.dataLabel!.text = dataObject
//        self.detailImage2.image = dataImage
    }
    
    
}

