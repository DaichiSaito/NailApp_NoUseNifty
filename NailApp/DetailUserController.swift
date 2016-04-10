//
//  ViewController.swift
//  ZDT_InstaTutorial
//
//  Created by Sztanyi Szabolcs on 22/12/15.
//  Copyright © 2015 Zappdesigntemplates. All rights reserved.
//

import UIKit

class DetailUserController: UIViewController {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileComment: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    var tmpCustomerId: String?
    var tmpUserName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = self.tmpCustomerId
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //        let cell = sender as! UICollectionViewCell
        //        let indexPath = self.collectionView!.indexPathForCell(cell)
        //        let controller = segue.destinationViewController as! DetailViewController
        //        controller.indexPath = indexPath!
        //        controller.imageInfo = self.imageInfo
//        let controller = segue.destinationViewController as! DetailUserController
        //        controller.customerId = self.imageInfo?.objectForKey("customerId") as! String
        print("segue")
        let controller = segue.destinationViewController as! CollectionViewMainController
        //        controller.customerId = self.imageInfo?.objectForKey("customerId") as! String
        controller.customerId = tmpCustomerId!
        
    }
}
