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
        userName.text = self.tmpUserName
        getProfileImagePath()
//        setProfileImage()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue")
        let controller = segue.destinationViewController as! CollectionViewMainController
        controller.userName = tmpUserName!
        
    }
    func setProfileImage() {
        print("setProfileImageの設定開始")
        //        //各値をセルに入れる
        let targetImageData = self.imageInfo[0]
        let url = NSURL(string: (targetImageData.objectForKey("imagePath") as? String)!)
        let placeholder = UIImage(named: "transparent.png")
        self.profileImage.setImageWithURL(url, placeholderImage: placeholder)
//        profileImage.layer.cornerRadius = 40
        
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
        if(self.tmpUserName == nil) {
            
        } else {
            query.whereKey("userName", equalTo: self.tmpUserName!)
            
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
