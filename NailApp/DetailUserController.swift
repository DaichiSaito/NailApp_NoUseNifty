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
    var imageInfo = []
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = self.tmpCustomerId
        getProfileImagePath()
//        setProfileImage()
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
    func setProfileImage() {
        print("setProfileImageの設定開始")
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MyCollectionViewCell
        //        //各値をセルに入れる
        //        let targetImageData: NSDictionary = self.imageInfo[indexPath.row] as! NSDictionary
        let targetImageData = self.imageInfo[0]
        //        let url = NSURL(string: targetImageData["imagePath"] as! String)
        //        let url = NSURL(fileURLWithPath: (targetImageData.objectForKey("imagePath") as? String)!)
        let url = NSURL(string: (targetImageData.objectForKey("imagePath") as? String)!)
        
        //        let url = NSURL(targetImageData
        let placeholder = UIImage(named: "transparent.png")
        self.profileImage.setImageWithURL(url, placeholderImage: placeholder)
        
    }
    func getProfileImagePath() {
        /**
         * Just FYI
         *
         * Example: 文字列と一致する場合
         * query.whereKey("title", equalTo: "xxx")
         *
         * メソッドのインターフェイスについて:
         * NCMBQuery.hを参照するとNCMBQueryのインスタンスメソッドの引数にとるべき値等が見れます。
         *
         */
        
        let query: NCMBQuery = NCMBQuery(className: "profileImage")
        if(self.tmpCustomerId == nil) {
            
        } else {
            query.whereKey("customerId", equalTo: self.tmpCustomerId!)
            
        }
        query.orderByDescending("createDate")
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            
            if error == nil {
                
                if objects.count > 0 {
                    
                    self.imageInfo = objects
                    self.setProfileImage()
                }
                
            } else {
                print(error.localizedDescription)
            }
        })

    }
}