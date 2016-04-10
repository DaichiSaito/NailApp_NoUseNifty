//
//  FirstViewController.swift
//  NailApp
//
//  Created by DaichiSaito on 2016/03/05.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit

class ownProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("test")
        performSegueWithIdentifier("profileSegue",sender: self)
    }
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear_ownProfileViewController")
//        self.setupPageViewController()
//        self.setupSegmentButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //        let cell = sender as! UICollectionViewCell
        //        let indexPath = self.collectionView!.indexPathForCell(cell)
        //        let controller = segue.destinationViewController as! DetailViewController
        //        controller.indexPath = indexPath!
        //        controller.imageInfo = self.imageInfo
        let controller = segue.destinationViewController as! DetailUserController
        //        controller.customerId = self.imageInfo?.objectForKey("customerId") as! String
//        controller.tmpCustomerId = self.imageInfo?.objectForKey("customerId") as! String
//        controller.tmpUserName = self.imageInfo?.objectForKey("customerId") as! String
        let carrentUser = NCMBUser.currentUser()
        print("carrentUser")
        print(carrentUser)
        controller.tmpCustomerId = carrentUser.userName
        controller.tmpUserName = carrentUser.userName
        
        
    }
    
}

